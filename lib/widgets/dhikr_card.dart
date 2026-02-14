// ignore_for_file: prefer_const_constructors, use_super_parameters, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/dhikr_item.dart';
import '../services/favorites_service.dart';

class DhikrCard extends StatefulWidget {
  final String text;
  final String category;
  final String? source;
  final double fontSize;
  final Color textColor;
  final Color containerColor;

  const DhikrCard({
    Key? key,
    required this.text,
    required this.category,
    this.source,
    this.fontSize = 24,
    this.textColor = const Color.fromARGB(255, 0, 0, 0),
    this.containerColor = const Color.fromARGB(255, 255, 255, 255),
  }) : super(key: key);

  @override
  State<DhikrCard> createState() => _DhikrCardState();
}

class _DhikrCardState extends State<DhikrCard> {
  late FavoritesService _favoritesService;
  bool _isFavorite = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initFavorites();
  }

  Future<void> _initFavorites() async {
    _favoritesService = await FavoritesService.getInstance();
    final id = _generateId();
    final isFav = await _favoritesService.isFavorite(id);
    if (mounted) {
      setState(() {
        _isFavorite = isFav;
        _isLoading = false;
      });
    }
  }

  String _generateId() {
    // Create a unique ID based on text and category
    return '${widget.category}_${widget.text.hashCode}';
  }

  Future<void> _toggleFavorite() async {
    final dhikr = DhikrItem(
      id: _generateId(),
      text: widget.text,
      category: widget.category,
      source: widget.source,
    );

    final newState = await _favoritesService.toggleFavorite(dhikr);

    if (mounted) {
      setState(() {
        _isFavorite = newState;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newState ? 'تمت الإضافة إلى المفضلة ♥' : 'تم الحذف من المفضلة',
            style: GoogleFonts.cairo(),
            textAlign: TextAlign.center,
          ),
          backgroundColor: newState ? Color(0xFF0B6623) : Colors.grey.shade700,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final effectiveContainerColor =
        isDark ? theme.colorScheme.surface : widget.containerColor;
    final effectiveTextColor =
        isDark ? theme.colorScheme.onSurface : widget.textColor;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: effectiveContainerColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Main content
          Padding(
            padding: EdgeInsets.only(top: 35),
            child: Column(
              children: [
                Text(
                  widget.text,
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: widget.fontSize,
                    color: effectiveTextColor,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (widget.source != null && widget.source!.isNotEmpty) ...[
                  SizedBox(height: 8),
                  Text(
                    widget.source!,
                    style: GoogleFonts.cairo(
                      fontSize: widget.fontSize * 0.7,
                      fontStyle: FontStyle.italic,
                      color: effectiveTextColor.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),

          // Favorite button
          Positioned(
            top: 0,
            right: 0,
            child: _isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF0B6623).withOpacity(0.5),
                      ),
                    ),
                  )
                : IconButton(
                    onPressed: _toggleFavorite,
                    icon: Icon(
                      _isFavorite ? Icons.bookmark : Icons.bookmark_border,
                      color: _isFavorite
                          ? Color(0xFFD4AF37) // Gold color
                          : Colors.grey.shade600,
                    ),
                    iconSize: 28,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    tooltip: _isFavorite ? 'حذف من المفضلة' : 'إضافة للمفضلة',
                  ),
          ),
        ],
      ),
    );
  }
}
