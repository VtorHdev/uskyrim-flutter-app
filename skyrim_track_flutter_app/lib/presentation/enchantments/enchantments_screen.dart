import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/domain/enums/enchantment_sort.dart';
import '/presentation/shared/widgets/item_list.dart';
import '/presentation/shared/widgets/item_card.dart';
import 'cubit/enchantments_cubit.dart';
import 'cubit/enchantments_state.dart';

class EnchantmentsScreen extends StatelessWidget {
  const EnchantmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encantamientos'),
        actions: const [_SortButton()],
      ),
      body: Column(
        children: [
          const _SearchField(),
          Expanded(
            child: BlocBuilder<EnchantmentsCubit, EnchantmentsState>(
              builder: (context, state) => state.map(
                initial: (_) => const SizedBox.shrink(),
                loading: (_) => const Center(
                  child: CircularProgressIndicator(color: Colors.amber),
                ),
                error: (state) => Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.amber),
                  ),
                ),
                loaded: (_) {
                  final enchantments = context
                      .read<EnchantmentsCubit>()
                      .getFilteredAndSortedEnchantments();
                  return ItemList(
                    itemCount: enchantments.length,
                    itemBuilder: (context, index) => ItemCard(
                      title: enchantments[index].name,
                      description: enchantments[index].effect,
                      isMarked: enchantments[index].isLearned,
                      onTap: () => context
                          .read<EnchantmentsCubit>()
                          .toggleItem(enchantments[index].id),
                    ),
                    emptyMessage: 'No se encontraron encantamientos',
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Buscar encantamientos...',
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              onChanged: context.read<EnchantmentsCubit>().updateSearch,
            ),
          ),
        ],
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  const _SortButton();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<EnchantmentSort>(
      icon: const Icon(Icons.sort),
      onSelected: context.read<EnchantmentsCubit>().updateSort,
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: EnchantmentSort.name,
          child: Text('Ordenar por nombre'),
        ),
        const PopupMenuItem(
          value: EnchantmentSort.status,
          child: Text('Ordenar por estado'),
        ),
      ],
    );
  }
}
