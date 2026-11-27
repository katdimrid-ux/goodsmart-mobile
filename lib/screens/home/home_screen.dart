import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/app_translations.dart';
import '../../core/theme/app_theme.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../cart/cart_screen.dart';
import '../location/location_picker_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedCategoryKey = 'all';
  String _selectedStore = 'Tout';
  String _searchQuery = '';
  bool _showFavoritesOnly = false;

  final List<String> _categoryKeys = [
    'all',
    'vegetables',
    'fruits',
    'grains',
    'grocery',
    'spices',
  ];

  void _openCart() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CartScreen()),
    );
  }

  void _showLocationPicker(String currentLang, String currentLocation) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const DeliveryAddressScreen()),
    );
  }

  void _showProductDetails(Product product, String lang) {
    int selectedQty = 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Consumer(
              builder: (context, ref, _) {
                final isFav =
                    ref.watch(favoritesProvider).contains(product.id);
                final cartNotifier = ref.read(cartProvider.notifier);
                final totalItemPrice = product.price * selectedQty;

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              product.imageUrl,
                              height: 185,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(
                                height: 185,
                                color: AppColors.background,
                                child: const Icon(Icons.eco_rounded,
                                    size: 60, color: AppColors.islandGreen),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: GestureDetector(
                              onTap: () => ref
                                  .read(favoritesProvider.notifier)
                                  .toggleFavorite(product.id),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isFav
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  color: isFav
                                      ? AppColors.error
                                      : AppColors.marineBlue,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.islandGreen.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.storefront_rounded,
                                size: 16, color: AppColors.islandGreen),
                            const SizedBox(width: 6),
                            Text(
                              '${AppTranslations.t(lang, 'sold_by')} ${product.store}',
                              style: const TextStyle(
                                color: AppColors.islandGreen,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              product.getName(lang),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppColors.marineBlue,
                              ),
                            ),
                          ),
                          Text(
                            'GHS ${totalItemPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.islandGreen,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        product.unit,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppTranslations.t(lang, 'quantity'),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: AppColors.marineBlue,
                              ),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (selectedQty > 1) {
                                      setModalState(() => selectedQty--);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.remove_rounded,
                                      size: 20,
                                      color: selectedQty > 1
                                          ? AppColors.marineBlue
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18),
                                  child: Text(
                                    '$selectedQty',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.marineBlue,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      setModalState(() => selectedQty++),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.islandGreen,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.add_rounded,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.background,
                                foregroundColor: AppColors.marineBlue,
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () {
                                cartNotifier.addItemWithQuantity(
                                    product, selectedQty);
                                Navigator.pop(ctx);
                              },
                              child: Text(
                                '${AppTranslations.t(lang, 'add_to_cart')} ($selectedQty)',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.marineBlue,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () {
                                cartNotifier.addItemWithQuantity(
                                    product, selectedQty);
                                Navigator.pop(ctx);
                                _openCart();
                              },
                              child: Text(
                                AppTranslations.t(lang, 'buy_now'),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final favorites = ref.watch(favoritesProvider);
    final lang = ref.watch(languageProvider);
    final location = ref.watch(locationProvider);
    final isLoggedIn = ref.watch(authProvider);

    final filteredProducts = dummyProducts.where((product) {
      final matchesCategory = _selectedCategoryKey == 'all' ||
          product.categoryKey == _selectedCategoryKey;
      final matchesStore =
          _selectedStore == 'Tout' || product.store == _selectedStore;
      final matchesFav =
          !_showFavoritesOnly || favorites.contains(product.id);
      final query = _searchQuery.toLowerCase();
      final matchesSearch =
          product.getName(lang).toLowerCase().contains(query) ||
              product.store.toLowerCase().contains(query);
      return matchesCategory && matchesStore && matchesFav && matchesSearch;
    }).toList();

    final langFlags = {
      'FR': '🇫🇷 FR',
      'EN': '🇬🇧 EN',
      'ZH': '🇨🇳 ZH',
      'JA': '🇯🇵 JA',
    };

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.surface,
      drawer: Drawer(
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(28)),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: isLoggedIn
                          ? AppColors.islandGreen
                          : AppColors.marineBlue,
                      child: const Icon(Icons.person_rounded,
                          color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isLoggedIn
                                ? 'Ridwane & Co.'
                                : AppTranslations.t(lang, 'guest_user'),
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: AppColors.marineBlue,
                            ),
                          ),
                          Text(
                            isLoggedIn
                                ? AppTranslations.t(lang, 'logged_user')
                                : location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLoggedIn)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.islandGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        ref.read(authProvider.notifier).signIn();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.login_rounded, size: 18),
                      label: Text(
                        AppTranslations.t(lang, 'sign_in'),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.home_rounded,
                    color: AppColors.marineBlue),
                title: Text(AppTranslations.t(lang, 'all'),
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  setState(() => _showFavoritesOnly = false);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.favorite_rounded,
                    color: AppColors.error),
                title: Text(AppTranslations.t(lang, 'favorites'),
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${favorites.length}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 12),
                  ),
                ),
                onTap: () {
                  setState(() => _showFavoritesOnly = true);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.receipt_long_rounded,
                    color: AppColors.marineBlue),
                title: Text(AppTranslations.t(lang, 'my_orders'),
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(context);
                  _openCart();
                },
              ),
              ListTile(
                leading: const Icon(Icons.location_on_outlined,
                    color: AppColors.marineBlue),
                title: Text(AppTranslations.t(lang, 'addresses'),
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(context);
                  _showLocationPicker(lang, location);
                },
              ),
              ListTile(
                leading: const Icon(Icons.support_agent_rounded,
                    color: AppColors.marineBlue),
                title: Text(AppTranslations.t(lang, 'support'),
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                onTap: () => Navigator.pop(context),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  tileColor: AppColors.background,
                  leading: const Icon(Icons.logout_rounded,
                      color: AppColors.error),
                  title: Text(
                    AppTranslations.t(lang, 'log_out'),
                    style: const TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onTap: () {
                    ref.read(authProvider.notifier).signOut();
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 1. Header minimaliste Bolt/Uber
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _scaffoldKey.currentState?.openDrawer(),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.menu_rounded,
                            color: AppColors.marineBlue),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showLocationPicker(lang, location),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppTranslations.t(lang, 'deliver_to'),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    location,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: AppColors.marineBlue,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_down_rounded,
                                    size: 18, color: AppColors.islandGreen),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    PopupMenuButton<String>(
                      color: AppColors.surface,
                      elevation: 6,
                      offset: const Offset(0, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onSelected: (val) =>
                          ref.read(languageProvider.notifier).setLanguage(val),
                      itemBuilder: (_) => langFlags.entries
                          .map(
                            (entry) => PopupMenuItem<String>(
                              value: entry.key,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    entry.value,
                                    style: TextStyle(
                                      fontWeight: entry.key == lang
                                          ? FontWeight.w800
                                          : FontWeight.w500,
                                      color: AppColors.marineBlue,
                                    ),
                                  ),
                                  if (entry.key == lang)
                                    const Icon(Icons.check_rounded,
                                        color: AppColors.islandGreen, size: 18),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 9),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Text(
                              langFlags[lang] ?? lang,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: AppColors.marineBlue,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.expand_more_rounded,
                                size: 16, color: AppColors.marineBlue),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _openCart,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.marineBlue,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.shopping_bag_outlined,
                                color: Colors.white, size: 20),
                          ),
                          if (cartNotifier.totalItems > 0)
                            Positioned(
                              right: -4,
                              top: -4,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  color: AppColors.islandGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${cartNotifier.totalItems}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. Barre de recherche
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: AppTranslations.t(lang, 'search_hint'),
                    hintStyle: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 14),
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            // 3. Carrousel des Magasins
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
                    child: Text(
                      AppTranslations.t(lang, 'stores'),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: AppColors.marineBlue,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 42,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: availableStores.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final store = availableStores[index];
                        final isSelected = store == _selectedStore;
                        final label = store == 'Tout'
                            ? AppTranslations.t(lang, 'all')
                            : store;

                        return GestureDetector(
                          onTap: () => setState(() => _selectedStore = store),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 9),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.marineBlue
                                  : AppColors.background,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                if (store != 'Tout') ...[
                                  Icon(
                                    Icons.storefront_rounded,
                                    size: 15,
                                    color: isSelected
                                        ? AppColors.islandGreen
                                        : AppColors.marineBlue,
                                  ),
                                  const SizedBox(width: 6),
                                ],
                                Text(
                                  label,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.marineBlue,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 14)),

            // 4. Carrousel des catégories
            SliverToBoxAdapter(
              child: SizedBox(
                height: 42,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: _categoryKeys.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final catKey = _categoryKeys[index];
                    final isSelected =
                        catKey == _selectedCategoryKey && !_showFavoritesOnly;
                    return GestureDetector(
                      onTap: () => setState(() {
                        _showFavoritesOnly = false;
                        _selectedCategoryKey = catKey;
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.islandGreen
                              : AppColors.background,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          AppTranslations.t(lang, catKey),
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppColors.marineBlue,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 18)),

            // 5. Grille produits à 2 colonnes
            filteredProducts.isEmpty
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Center(
                        child: Text(
                          AppTranslations.t(lang, 'no_favorites'),
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 14),
                        ),
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.70,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = filteredProducts[index];
                          final qty = cart[product.id]?.quantity ?? 0;
                          final isFav = favorites.contains(product.id);

                          return GestureDetector(
                            onTap: () => _showProductDetails(product, lang),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          child: Image.network(
                                            product.imageUrl,
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, _, _) =>
                                                Container(
                                              color: Colors.white,
                                              child: const Icon(
                                                  Icons.eco_rounded,
                                                  color: AppColors.islandGreen,
                                                  size: 40),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 6,
                                          right: 6,
                                          child: GestureDetector(
                                            onTap: () => ref
                                                .read(
                                                    favoritesProvider.notifier)
                                                .toggleFavorite(product.id),
                                            child: Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                isFav
                                                    ? Icons.favorite_rounded
                                                    : Icons
                                                        .favorite_border_rounded,
                                                size: 15,
                                                color: isFav
                                                    ? AppColors.error
                                                    : AppColors.marineBlue,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    product.store,
                                    style: const TextStyle(
                                      color: AppColors.islandGreen,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    product.getName(lang),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: AppColors.marineBlue,
                                    ),
                                  ),
                                  Text(
                                    product.unit,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'GHS ${product.price.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 15,
                                          color: AppColors.marineBlue,
                                        ),
                                      ),
                                      qty == 0
                                          ? GestureDetector(
                                              onTap: () =>
                                                  cartNotifier.addItem(product),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  color: AppColors.islandGreen,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: const Icon(
                                                    Icons.add_rounded,
                                                    color: Colors.white,
                                                    size: 18),
                                              ),
                                            )
                                          : Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () => cartNotifier
                                                      .removeSingleItem(
                                                          product.id),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: const Icon(
                                                        Icons.remove_rounded,
                                                        size: 16,
                                                        color: AppColors
                                                            .marineBlue),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 6),
                                                  child: Text(
                                                    '$qty',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () => cartNotifier
                                                      .addItem(product),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppColors.islandGreen,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: const Icon(
                                                        Icons.add_rounded,
                                                        size: 16,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: filteredProducts.length,
                      ),
                    ),
                  ),
            const SliverToBoxAdapter(child: SizedBox(height: 85)),
          ],
        ),
      ),
      bottomSheet: cartNotifier.totalItems > 0
          ? Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              color: AppColors.surface,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.marineBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _openCart,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '${cartNotifier.totalItems} ${AppTranslations.t(lang, 'items')}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      AppTranslations.t(lang, 'view_cart'),
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 15),
                    ),
                    Text(
                      'GHS ${cartNotifier.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.islandGreen,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}