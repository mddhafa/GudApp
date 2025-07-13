import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gudapp/data/model/response/barang_masuk_resonse_model.dart';
import 'package:gudapp/data/model/response/barang_keluar_respone_model.dart';
import 'package:gudapp/data/model/response/items_response_model.dart';
import 'package:gudapp/presentation/barangkeluar/bloc/barangkeluar_bloc.dart';
import 'package:gudapp/presentation/items/bloc/items_bloc.dart';
import 'package:gudapp/presentation/barangmasuk/bloc/baranng_masuk_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class DashboardAdminScreen extends StatefulWidget {
  const DashboardAdminScreen({super.key});

  @override
  State<DashboardAdminScreen> createState() => _DashboardAdminScreenState();
}

class _DashboardAdminScreenState extends State<DashboardAdminScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ItemsBloc>().add(GetItemsList());
    context.read<BaranngMasukBloc>().add(GetBarangMasukList());
    context.read<BarangkeluarBloc>().add(GetBarangKeluarList());
  }

  Widget _buildStockChart(List<ItemsDatum> items) {
    final List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < items.length; i++) {
      final stock = items[i].stock?.toDouble() ?? 0;
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: stock,
              width: 18,
              borderRadius: BorderRadius.circular(4),
              color: Colors.blueAccent,
            ),
          ],
        ),
      );
    }

    return _buildChartCard(
      title: 'Grafik Stok Barang',
      barGroups: barGroups,
      bottomTitles: items.map((e) => e.name ?? '').toList(),
    );
  }

  // Widget _buildBarangMasukChart(List<Datum> data) {
  //   final Map<String, double> grouped = {};
  //   for (var item in data) {
  //     final date = DateFormat(
  //       'dd MMM',
  //     ).format(item.tanggalMasuk ?? DateTime.now());
  //     grouped[date] = (grouped[date] ?? 0) + (item.jumlah?.toDouble() ?? 0);
  //   }

  //   final sortedKeys = grouped.keys.toList()..sort();
  //   final barGroups = <BarChartGroupData>[];

  //   for (int i = 0; i < sortedKeys.length; i++) {
  //     barGroups.add(
  //       BarChartGroupData(
  //         x: i,
  //         barRods: [
  //           BarChartRodData(
  //             toY: grouped[sortedKeys[i]] ?? 0,
  //             width: 18,
  //             borderRadius: BorderRadius.circular(4),
  //             color: Colors.green,
  //           ),
  //         ],
  //       ),
  //     );
  //   }

  //   return _buildChartCard(
  //     title: 'Grafik Barang Masuk',
  //     barGroups: barGroups,
  //     bottomTitles: sortedKeys,
  //   );
  // }

  Widget _buildBarangMasukChart(List<Datum> data) {
    final Map<String, double> grouped = {};
    for (var item in data) {
      final date = DateFormat(
        'dd MMM yyyy',
      ).format(item.tanggalMasuk ?? DateTime.now());
      grouped[date] = (grouped[date] ?? 0) + (item.quantity?.toDouble() ?? 0);
    }

    final sortedKeys = grouped.keys.toList()..sort();
    final barGroups = <BarChartGroupData>[];

    for (int i = 0; i < sortedKeys.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: grouped[sortedKeys[i]] ?? 0,
              width: 18,
              borderRadius: BorderRadius.circular(4),
              color: Colors.green,
            ),
          ],
        ),
      );
    }
    return _buildChartCard(
      title: 'Grafik Barang Masuk',
      barGroups: barGroups,
      bottomTitles: sortedKeys,
    );
  }

  Widget _buildBarangKeluarChart(List<BarangKeluarDatum> data) {
    final Map<String, double> grouped = {};
    for (var item in data) {
      final date = DateFormat(
        'dd MMM yyyy',
      ).format(item.tanggalKeluar ?? DateTime.now());
      grouped[date] = (grouped[date] ?? 0) + (item.quantity?.toDouble() ?? 0);
    }

    final sortedKeys = grouped.keys.toList()..sort();
    final barGroups = <BarChartGroupData>[];

    for (int i = 0; i < sortedKeys.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: grouped[sortedKeys[i]] ?? 0,
              width: 18,
              borderRadius: BorderRadius.circular(4),
              color: Colors.red,
            ),
          ],
        ),
      );
    }
    return _buildChartCard(
      title: 'Grafik Barang Keluar',
      barGroups: barGroups,
      bottomTitles: sortedKeys,
    );
  }

  Widget _buildChartCard({
    required String title,
    required List<BarChartGroupData> barGroups,
    required List<String> bottomTitles,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 2.2,
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.black87,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final name = bottomTitles[group.x];
                        return BarTooltipItem(
                          '$name\nJumlah: ${rod.toY.toInt()}',
                          const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget:
                            (value, _) => Text(
                              value.toInt().toString(),
                              style: const TextStyle(fontSize: 10),
                            ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 48,
                        getTitlesWidget: (value, _) {
                          final index = value.toInt();
                          if (index < 0 || index >= bottomTitles.length) {
                            return const SizedBox.shrink();
                          }
                          final label = bottomTitles[index];
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              label.length > 8
                                  ? '${label.substring(0, 8)}…'
                                  : label,
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: barGroups,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ItemsBloc>().add(GetItemsList());
        context.read<BaranngMasukBloc>().add(GetBarangMasukList());
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Dashboard Admin',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Selamat datang, berikut statistik terkini:',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          /// Grafik Stok Barang
          BlocBuilder<ItemsBloc, ItemsState>(
            builder: (context, state) {
              if (state is ItemsLoaded && state.data.isNotEmpty) {
                return _buildStockChart(state.data.cast<ItemsDatum>());
              } else if (state is ItemsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ItemsError) {
                return Text(state.message);
              }
              return const SizedBox();
            },
          ),

          /// Grafik Barang Masuk
          BlocBuilder<BaranngMasukBloc, BaranngMasukState>(
            builder: (context, state) {
              if (state is BaranngMasukLoaded && state.data.isNotEmpty) {
                return _buildBarangMasukChart(state.data.cast<Datum>());
              } else if (state is BaranngMasukLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BaranngMasukError) {
                return Text(state.message);
              }
              return const SizedBox();
            },
          ),

          /// Grafik Barang Keluar
          BlocBuilder<BarangkeluarBloc, BarangkeluarState>(
            builder: (context, state) {
              if (state is BarangkeluarLoaded && state.data.isNotEmpty) {
                return _buildBarangKeluarChart(
                  state.data.cast<BarangKeluarDatum>(),
                );
              } else if (state is BarangkeluarLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BarangkeluarError) {
                return Text(state.message);
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
