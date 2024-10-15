import 'package:example/bloc/counter_bloc.dart';
import 'package:example/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:reusable_bloc_base/reusable_bloc_base.dart';
import 'package:toastification/toastification.dart';

void main() {
  BlocStateReactor.showLoading = (context) => context.loaderOverlay.show();
  BlocStateReactor.hideLoading = (context) => context.loaderOverlay.hide();
  BlocStateReactor.onSuccessState = (context, success) {
    toastification.show(
      context: context,
      title: Text(success.translate()),
      autoCloseDuration: const Duration(seconds: 3),
      style: ToastificationStyle.minimal,
      type: ToastificationType.success,
    );
  };
  BlocStateReactor.onErrorState = (context, failure) {
    toastification.show(
      context: context,
      title: Text(failure.translate()),
      autoCloseDuration: const Duration(seconds: 3),
      style: ToastificationStyle.minimal,
      type: ToastificationType.error,
    );
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      overlayWidgetBuilder: (_) {
        return const LoadingIndicator();
      },
      overlayColor: Colors.black.withOpacity(0.4),
      overlayHeight: MediaQuery.of(context).size.height,
      overlayWidth: MediaQuery.of(context).size.width,
      child: ToastificationWrapper(
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: BlocProvider(
            create: (context) => CounterBloc(),
            child: const MyHomePage(title: 'Flutter Demo Home Page'),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return BaseStateListener<void, CounterBloc, CounterState>(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              BlocBuilder<CounterBloc, CounterState>(
                builder: (context, state) {
                  return Text(
                    state.counter.toString(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    context
                        .read<CounterBloc>()
                        .add(const IncrementCounterEvent());
                  },
                  child: const Text('Increment')),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    context
                        .read<CounterBloc>()
                        .add(const DecrementCounterEvent());
                  },
                  child: const Text('Decrement')),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    context.read<CounterBloc>().add(const ShowFailureEvent());
                  },
                  child: const Text('Trigger failure')),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    context
                        .read<CounterBloc>()
                        .add(const PrintBlocHistoryEvent());
                  },
                  child: const Text('Print last 10 bloc state')),
              BlocBuilder<CounterBloc, CounterState>(
                builder: (context, state) {
                  return SizedBox(
                    height: 500,
                    child: ListView(
                      children: [
                        Text(
                          state.blocHistory,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
