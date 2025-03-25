import 'package:baixa_tube/core/routes/routes.dart';
import 'package:baixa_tube/core/widgets/buttons/button_primary.dart';
import 'package:baixa_tube/ui/blocs/library/cubit/library_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  late LibraryBloc libraryBloc;
  @override
  void initState() {
    libraryBloc = context.read<LibraryBloc>();
    libraryBloc.getSounds();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Biblioteca'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.go(Routes.home);
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (state is LibraryLoading) const CircularProgressIndicator(),
                if (state.songs?.isNotEmpty ?? false) ...[
                  for (final song in state.songs!)
                    InkWell(
                      onTap: () {
                        libraryBloc.setCurrentSound(song);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: state.currentSong == song ? Colors.blue[300] : Colors.white,
                          border: const Border(
                            top: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Image.network(
                              song.thumb,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                song.title,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                libraryBloc.deleteSound(song, context);
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                ],
                if (state is LibraryError)
                  Column(
                    children: [
                      Text(state.message),
                      ButtonPrimary(
                          text: 'Limpar tudo',
                          loading: false,
                          onPressed: () {
                            libraryBloc.clearData();
                          })
                    ],
                  ),
              ],
            ),
          ),
          bottomSheet: BlocBuilder<LibraryBloc, LibraryState>(
            builder: (context, state) {
              if (state is! LibrarySuccess) {
                return const SizedBox.shrink();
              }
              return Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_previous),
                      onPressed: () {
                        libraryBloc.previousSound();
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        state.isPlaying! ? Icons.pause : Icons.play_arrow,
                      ),
                      onPressed: () {
                        state.isPlaying! ? libraryBloc.pauseSound() : libraryBloc.playSound();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      onPressed: () {
                        libraryBloc.nextSound();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
