import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sip_sales_clean/presentation/cubit/counter_cubit.dart';
import 'package:sip_sales_clean/presentation/themes/styles.dart';

class Counter {
  static Widget automaticPerson(
    BuildContext context,
    String name,
    List<String> types, {
    String type = '',
  }) {
    return Row(
      children: [
        Expanded(child: Text(name, style: TextThemes.subtitle)),
        Expanded(
          child: BlocBuilder<CounterCubit, Map<String, int>>(
            builder: (context, state) {
              final total = types.fold(
                0,
                (previousValue, element) =>
                    previousValue + (state[element] ?? 0),
              );

              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$total orang',
                  style: TextThemes.normal.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  static Widget person(
    BuildContext context,
    String type,
    String name, {
    int defaultNumber = 1,
  }) {
    return Row(
      children: [
        Expanded(child: Text(name, style: TextThemes.subtitle)),
        Expanded(
          child: BlocBuilder<CounterCubit, Map<String, int>>(
            builder: (context, map) {
              final count = map[type] ?? defaultNumber;

              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(8),
                child: Row(
                  spacing: 12,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // ~:Decrement Button:~
                    InkWell(
                      onTap: () => context.read<CounterCubit>().decrement(type),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.remove, size: 16),
                      ),
                    ),

                    // ~:Counter Text:~
                    Text('$count orang', style: TextThemes.normal),

                    // ~:Increment Button:~
                    InkWell(
                      onTap: () => context.read<CounterCubit>().increment(type),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.add, size: 16),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
