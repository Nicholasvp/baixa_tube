import 'package:baixa_tube/core/routes/routes.dart';
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
  @override
  void initState() {
    super.initState();
    final bloc = context.read<LibraryBloc>();
    bloc.getSounds(context);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LibraryBloc>();

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
          body: Column(
            children: [
              if (state is LibraryLoading) const CircularProgressIndicator(),
              if (state is LibrarySuccess) ...[
                for (final path in state.paths)
                  ListTile(
                    title: Text(path),
                    onTap: () => bloc.playSound(path),
                  )
              ],
              if (state is LibraryError) Text(state.message),
            ],
          ),
        );
      },
    );
  }
}
