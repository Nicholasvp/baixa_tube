import 'package:baixa_tube/core/routes/routes.dart';
import 'package:baixa_tube/core/widgets/buttons/button_primary.dart';
import 'package:baixa_tube/core/widgets/gaps/gap.dart';
import 'package:baixa_tube/core/widgets/snackbars/snackbar_app.dart';
import 'package:baixa_tube/core/widgets/text_field/text_field_primary.dart';
import 'package:baixa_tube/ui/blocs/home/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                        const Text(
                          'Baixa Tube',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
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
          ],
        ),
      ),
    );
  }
}
