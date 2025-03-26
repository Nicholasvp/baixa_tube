import 'dart:io';

import 'package:baixa_tube/core/routes/routes.dart';
import 'package:baixa_tube/core/widgets/buttons/button_primary.dart';
import 'package:baixa_tube/core/widgets/gaps/gap.dart';
import 'package:baixa_tube/core/widgets/snackbars/snackbar_app.dart';
import 'package:baixa_tube/core/widgets/text_field/text_field_primary.dart';
import 'package:baixa_tube/ui/blocs/home/home_bloc.dart';
import 'package:ffmpeg_helper/helpers/ffmpeg_helper_class.dart';
import 'package:ffmpeg_helper/helpers/helper_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final downloadProgress = ValueNotifier<FFMpegProgress?>(null);
  bool ffmpegPresent = false;
  final ffmpeg = FFMpegHelper.instance;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      downloadFFMpeg();
    });
    super.initState();
  }

  Future<void> verifyFFMpeg() async {
    if (Platform.isWindows) {
      final success = await ffmpeg.isFFMpegPresent();
      setState(() {
        ffmpegPresent = success;
      });
    }
  }

  Future<void> downloadFFMpeg() async {
    await verifyFFMpeg();
    if (Platform.isWindows && !ffmpegPresent) {
      bool success = await ffmpeg.setupFFMpegOnWindows(
        onProgress: (FFMpegProgress progress) {
          downloadProgress.value = progress;
        },
      );
      setState(() {
        ffmpegPresent = success;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                if (!ffmpegPresent && downloadProgress.value != null)
                  SizedBox(
                    width: 300,
                    child: ValueListenableBuilder<FFMpegProgress?>(
                      valueListenable: downloadProgress,
                      builder: (BuildContext context, FFMpegProgress? value, _) {
                        print(value!.downloaded / value.fileSize);
                        double? prog;
                        if ((value.downloaded != 0) && (value.fileSize != 0)) {
                          prog = value.downloaded / value.fileSize;
                        } else {
                          prog = 0;
                        }
                        if (value.phase == FFMpegProgressPhase.decompressing) {
                          prog = null;
                        }
                        if (value.phase == FFMpegProgressPhase.inactive) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(value.phase.name),
                            const SizedBox(height: 5),
                            LinearProgressIndicator(value: prog),
                          ],
                        );
                      },
                    ),
                  ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    context.go(Routes.library);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('IR PARA A BIBLIOTECA', style: TextStyle(color: Colors.white)),
                        IconButton(
                          icon: const Icon(
                            Icons.library_books,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            context.go('/library');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 400,
                height: 300,
                padding: const EdgeInsets.all(32),
                child: BlocConsumer<HomeBloc, HomeState>(
                  listener: (context, state) {
                    if (state is HomeSuccess) {
                      SnackbarApp.show(context, 'Download concluído ${state.path}', SnackbarType.success);
                    } else if (state is HomeError) {
                      SnackbarApp.show(context, state.message, SnackbarType.error);
                    }
                  },
                  builder: (context, state) {
                    final homeBloc = context.read<HomeBloc>();
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Baixa Tube',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Image.asset(
                              'assets/icons/baixa_tube_logo.png',
                              width: 50,
                              height: 50,
                            ),
                          ],
                        ),
                        Gap.medium,
                        TextFieldPrimary(
                          hintText: 'URL',
                          controller: homeBloc.urlController,
                          required: true,
                        ),
                        Gap.large,
                        const SizedBox(height: 20),
                        BlocConsumer<HomeBloc, HomeState>(
                          listener: (context, state) {
                            if (state is HomeSuccess) {
                              context.go(Routes.library);
                            }
                          },
                          builder: (context, state) {
                            return ButtonPrimary(
                              onPressed: () {
                                homeBloc.download();
                              },
                              text: 'Baixar',
                              loading: state is HomeLoading,
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  child: InkWell(
                    onTap: () {
                      launchUrl(Uri.parse('https://github.com/nicholasvp'));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('Feito por nicholasvp', style: TextStyle(color: Colors.white)),
                        Gap.medium,
                        SvgPicture.asset(
                          'assets/icons/github.svg',
                          width: 24,
                          height: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Gap.extraLarge,
          ],
        ),
      ),
    );
  }
}
