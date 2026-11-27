import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/app_translations.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/cart_provider.dart';

class AccraPlace {
  final String title;
  final String subtitle;
  final double mapX;
  final double mapY;

  const AccraPlace({
    required this.title,
    required this.subtitle,
    required this.mapX,
    required this.mapY,
  });
}

const List<AccraPlace> accraPlaces = [
  AccraPlace(
    title: 'Jubilee Drive',
    subtitle: 'Legon Campus, Accra',
    mapX: 0.48,
    mapY: 0.36,
  ),
  AccraPlace(
    title: 'International Student Hostel (ISH)',
    subtitle: 'Legon Campus, Accra',
    mapX: 0.56,
    mapY: 0.24,
  ),
  AccraPlace(
    title: 'TF Hostels',
    subtitle: 'University of Ghana, Legon',
    mapX: 0.42,
    mapY: 0.28,
  ),
  AccraPlace(
    title: 'James Topp Nelson Yankah Hall',
    subtitle: 'Legon Campus, Accra',
    mapX: 0.36,
    mapY: 0.44,
  ),
  AccraPlace(
    title: 'Alajo T-Junction',
    subtitle: 'Alajo St, Accra',
    mapX: 0.30,
    mapY: 0.65,
  ),
  AccraPlace(
    title: 'Luciana Boulevard 17',
    subtitle: 'Madina, Accra',
    mapX: 0.64,
    mapY: 0.18,
  ),
  AccraPlace(
    title: 'East Legon A&C Mall',
    subtitle: 'Jungle Ave, Accra',
    mapX: 0.76,
    mapY: 0.42,
  ),
  AccraPlace(
    title: 'Osu Oxford Street',
    subtitle: 'Osu, Accra',
    mapX: 0.66,
    mapY: 0.80,
  ),
];

/// Écran 1 : Liste des adresses avec bouton "Modifier" (style Bolt Food)
class DeliveryAddressScreen extends ConsumerStatefulWidget {
  const DeliveryAddressScreen({super.key});

  @override
  ConsumerState<DeliveryAddressScreen> createState() =>
      _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends ConsumerState<DeliveryAddressScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  void _openPinGridEditor(AccraPlace initialPlace) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PinGridAdjustScreen(initialPlace: initialPlace),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final currentLocation = ref.watch(locationProvider);

    final activePlace = accraPlaces.firstWhere(
      (p) => currentLocation.contains(p.title),
      orElse: () => accraPlaces.first,
    );

    final filteredPlaces = accraPlaces.where((p) {
      final q = _query.toLowerCase();
      return p.title.toLowerCase().contains(q) ||
          p.subtitle.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.marineBlue),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          AppTranslations.t(lang, 'delivery_address_title'),
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 17,
            color: AppColors.marineBlue,
          ),
        ),
      ),
      body: Column(
        children: [
          // Carte de l'adresse par défaut actuelle + bouton "Modifier"
          Container(
            margin: const EdgeInsets.fromLTRB(20, 8, 20, 14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.islandGreen.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.location_on_rounded,
                      color: AppColors.islandGreen, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppTranslations.t(lang, 'current_location'),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        currentLocation,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: AppColors.marineBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.marineBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _openPinGridEditor(activePlace),
                  child: Text(
                    AppTranslations.t(lang, 'modify_btn'),
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          // Barre de recherche de quartier
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _query = val),
              decoration: InputDecoration(
                hintText: AppTranslations.t(lang, 'enter_new_address'),
                hintStyle: const TextStyle(
                    fontSize: 14, color: AppColors.textSecondary),
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppColors.marineBlue),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Raccourci direct "Ajuster le pin sur la grille"
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.islandGreen.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.pin_drop_rounded,
                  color: AppColors.islandGreen, size: 20),
            ),
            title: Text(
              AppTranslations.t(lang, 'choose_on_grid'),
              style: const TextStyle(
                color: AppColors.islandGreen,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: AppColors.islandGreen),
            onTap: () => _openPinGridEditor(activePlace),
          ),

          // Liste des quartiers disponibles
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              itemCount: filteredPlaces.length,
              separatorBuilder: (_, _) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final place = filteredPlaces[index];
                final isSelected = currentLocation.contains(place.title);

                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  leading: const Icon(Icons.location_on_outlined,
                      color: AppColors.marineBlue),
                  title: Text(
                    place.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.marineBlue,
                    ),
                  ),
                  subtitle: Text(
                    place.subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  trailing: isSelected
                      ? const CircleAvatar(
                          radius: 12,
                          backgroundColor: AppColors.islandGreen,
                          child: Icon(Icons.check_rounded,
                              color: Colors.white, size: 15),
                        )
                      : null,
                  onTap: () {
                    // Ouvre directement la grille centrée sur le quartier choisi pour ajuster le pin
                    _openPinGridEditor(place);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Écran 2 : Grille plein écran avec Pin ajustable + saut automatique lors de la saisie
class PinGridAdjustScreen extends ConsumerStatefulWidget {
  final AccraPlace initialPlace;

  const PinGridAdjustScreen({super.key, required this.initialPlace});

  @override
  ConsumerState<PinGridAdjustScreen> createState() =>
      _PinGridAdjustScreenState();
}

class _PinGridAdjustScreenState extends ConsumerState<PinGridAdjustScreen> {
  late TextEditingController _addressController;
  late double _pinX;
  late double _pinY;
  late String _activeTitle;

  @override
  void initState() {
    super.initState();
    _activeTitle =
        '${widget.initialPlace.title}, ${widget.initialPlace.subtitle}';
    _addressController = TextEditingController(text: _activeTitle);
    _pinX = widget.initialPlace.mapX;
    _pinY = widget.initialPlace.mapY;
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  /// Saute automatiquement sur le quartier correspondant pendant la saisie
  void _onAddressTyped(String value) {
    setState(() {
      _activeTitle = value.trim().isEmpty ? 'Accra, Ghana' : value.trim();
    });

    final q = value.toLowerCase().trim();
    if (q.length < 2) return;

    for (final place in accraPlaces) {
      if (place.title.toLowerCase().contains(q) ||
          place.subtitle.toLowerCase().contains(q)) {
        setState(() {
          _pinX = place.mapX;
          _pinY = place.mapY;
        });
        break;
      }
    }
  }

  void _updatePinFromTouch(Offset localPos, double width, double height) {
    setState(() {
      _pinX = (localPos.dx / width).clamp(0.08, 0.92);
      _pinY = (localPos.dy / height).clamp(0.14, 0.86);
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // Zone supérieure : Grille interactive plein écran
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;

                return GestureDetector(
                  onTapDown: (d) => _updatePinFromTouch(d.localPosition, w, h),
                  onPanUpdate: (d) =>
                      _updatePinFromTouch(d.localPosition, w, h),
                  child: Stack(
                    children: [
                      // Fond grille urbaine type Bolt Food
                      CustomPaint(
                        size: Size(w, h),
                        painter: _DetailedStreetGridPainter(),
                      ),

                      // Repères de quartiers sur la grille
                      ...accraPlaces.map(
                        (place) => Positioned(
                          left: (place.mapX * w - 45).clamp(8.0, w - 110),
                          top: (place.mapY * h + 16).clamp(50.0, h - 40),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _pinX = place.mapX;
                                _pinY = place.mapY;
                                _activeTitle =
                                    '${place.title}, ${place.subtitle}';
                                _addressController.text = _activeTitle;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.88),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.circle,
                                      size: 7, color: AppColors.textSecondary),
                                  const SizedBox(width: 4),
                                  Text(
                                    place.title,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.marineBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Bouton Fermer en haut à gauche
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 12,
                        left: 16,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close_rounded,
                                color: AppColors.marineBlue, size: 22),
                          ),
                        ),
                      ),

                      // Bouton Recentrer GPS en bas à droite de la grille
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _pinX = 0.48;
                              _pinY = 0.36;
                              _activeTitle = 'Jubilee Drive, Legon Campus';
                              _addressController.text = _activeTitle;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.near_me_rounded,
                                color: AppColors.marineBlue, size: 22),
                          ),
                        ),
                      ),

                      // Pin vert ajustable + bulle noire "Mark building entrance"
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        left: (_pinX * w - 95).clamp(8.0, w - 190),
                        top: (_pinY * h - 78).clamp(40.0, h - 90),
                        child: SizedBox(
                          width: 190,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 7),
                                decoration: BoxDecoration(
                                  color: AppColors.marineBlue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  AppTranslations.t(lang, 'mark_entrance'),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.islandGreen
                                      .withValues(alpha: 0.22),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.location_on_rounded,
                                    color: AppColors.islandGreen,
                                    size: 36,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Panneau blanc inférieur (reste toujours visible avec la grille ouverte)
          Container(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 26),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppTranslations.t(lang, 'set_delivery_address'),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.marineBlue,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _addressController,
                  onChanged: _onAddressTyped,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.marineBlue,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: AppColors.marineBlue),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        _addressController.clear();
                        _onAddressTyped('');
                      },
                    ),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  AppTranslations.t(lang, 'move_pin_hint'),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.islandGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    onPressed: () {
                      final finalText = _addressController.text.trim().isEmpty
                          ? 'Jubilee Drive, Legon Campus'
                          : _addressController.text.trim();
                      ref
                          .read(locationProvider.notifier)
                          .setLocation(finalText);
                      // Ferme la grille ET la liste d'adresses pour revenir à l'accueil
                      Navigator.of(context)
                        ..pop()
                        ..pop();
                    },
                    child: Text(
                      AppTranslations.t(lang, 'set_address_btn'),
                      style: const TextStyle(
                        fontSize: 16,
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
    );
  }
}

class _DetailedStreetGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final blockPaint = Paint()..color = const Color(0xFFE2E8F0);
    final buildingPaint = Paint()..color = const Color(0xFFCBD5E1);
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    // Quadrillage léger
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.65)
      ..strokeWidth = 1.5;

    for (double x = 0; x < size.width; x += 42) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 42) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Blocs urbains
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width * 0.12, size.height * 0.18, 70, 48),
          const Radius.circular(8)),
      blockPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width * 0.62, size.height * 0.52, 85, 55),
          const Radius.circular(8)),
      buildingPaint,
    );

    // Axes routiers principaux
    canvas.drawLine(Offset(0, size.height * 0.38),
        Offset(size.width, size.height * 0.32), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.72),
        Offset(size.width, size.height * 0.68), roadPaint);
    canvas.drawLine(Offset(size.width * 0.48, 0),
        Offset(size.width * 0.44, size.height), roadPaint);
    canvas.drawLine(Offset(size.width * 0.74, 0),
        Offset(size.width * 0.68, size.height), roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}