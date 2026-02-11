import 'package:flutter/material.dart';
import 'dart:ui';
import '../Screens/games_screen.dart';
import '../themes/app_theme.dart';
import '../themes/app_colors.dart';

class AppNavBar extends StatefulWidget implements PreferredSizeWidget {
  const AppNavBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  State<AppNavBar> createState() => _AppNavBarState();
}

class _AppNavBarState extends State<AppNavBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 720;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.5),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOutCubic,
        )),
        child: Container(
          height: 100,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 32,
            vertical: 16,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: _FloatingNavContent(isMobile: isMobile),
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatingNavContent extends StatelessWidget {
  const _FloatingNavContent({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.08),
                Colors.white.withOpacity(0.04),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.vibrantPink.withOpacity(0.1),
                blurRadius: 30,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: isMobile ? _buildMobileNav(context) : _buildDesktopNav(context),
        ),
      ),
    );
  }

  Widget _buildDesktopNav(BuildContext context) {
    return Row(
      children: [
        // 1. BRAND LOGO with animated glow
        _AnimatedBrandLogo(),
        const Spacer(),

        // 2. NAVIGATION LINKS
        _NavBarLink(
          title: "RED FLAG SCANNER",
          icon: Icons.security_rounded,
          isActive: true,
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
        const SizedBox(width: 8),
        _NavBarLink(
          title: "SCAM RISK",
          icon: Icons.shield_outlined,
          onPressed: () {},
        ),
        const SizedBox(width: 8),
        _NavBarLink(
          title: "GAMES",
          icon: Icons.sports_esports_rounded,
          onPressed: () => Navigator.pushReplacementNamed(context, '/game'),
        ),

        const SizedBox(width: 24),

        // 3. PREMIUM FEATURE
        _FloatingPremiumButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Premium Plans coming soon! 💎"),
                backgroundColor: AppColors.vibrantPurple,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
        ),

        const SizedBox(width: 12),

        // 4. LOGIN BUTTON
        _FloatingLoginButton(onPressed: () {}),
      ],
    );
  }

  Widget _buildMobileNav(BuildContext context) {
    return Row(
      children: [
        _AnimatedBrandLogo(),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.menu_rounded, color: Colors.white),
          onPressed: () {
            // Show mobile menu
            _showMobileMenu(context);
          },
        ),
      ],
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _MobileMenuSheet(),
    );
  }
}

// === ANIMATED BRAND LOGO ===
class _AnimatedBrandLogo extends StatefulWidget {
  @override
  State<_AnimatedBrandLogo> createState() => _AnimatedBrandLogoState();
}

class _AnimatedBrandLogoState extends State<_AnimatedBrandLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: () => Navigator.pushReplacementNamed(context, '/home'),
        child: AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: _isHovering
                    ? LinearGradient(
                  colors: [
                    AppColors.vibrantPink.withOpacity(0.2),
                    AppColors.vibrantPurple.withOpacity(0.2),
                  ],
                )
                    : null,
              ),
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    AppColors.vibrantPink,
                    AppColors.vibrantPurple,
                    AppColors.vibrantCyan,
                  ],
                  stops: [
                    0.0,
                    0.5 + _glowController.value * 0.3,
                    1.0,
                  ],
                ).createShader(bounds),
                child: Text(
                  "D A T E  S H I E L D",
                  style: AppTheme.bebas(
                    size: 28,
                    letterSpacing: 2.5,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// === NAV BAR LINK WITH HOVER EFFECT ===
class _NavBarLink extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isActive;

  const _NavBarLink({
    required this.title,
    required this.icon,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  State<_NavBarLink> createState() => _NavBarLinkState();
}

class _NavBarLinkState extends State<_NavBarLink> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: widget.isActive
              ? AppColors.vibrantPink.withOpacity(0.15)
              : _isHovering
              ? Colors.white.withOpacity(0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: widget.isActive
              ? Border.all(
            color: AppColors.vibrantPink.withOpacity(0.4),
            width: 1,
          )
              : null,
        ),
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: widget.isActive
                    ? AppColors.vibrantPink
                    : _isHovering
                    ? Colors.white
                    : Colors.white.withOpacity(0.7),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                widget.title,
                style: AppTheme.bebas(
                  size: 15,
                  letterSpacing: 1.2,
                  color: widget.isActive
                      ? Colors.white
                      : _isHovering
                      ? Colors.white
                      : Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// === FLOATING PREMIUM BUTTON ===
class _FloatingPremiumButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _FloatingPremiumButton({required this.onPressed});

  @override
  State<_FloatingPremiumButton> createState() => _FloatingPremiumButtonState();
}

class _FloatingPremiumButtonState extends State<_FloatingPremiumButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedScale(
        scale: _isHovering ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: AnimatedBuilder(
          animation: _shimmerController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.amber,
                    Colors.orange.shade700,
                    Colors.amber,
                  ],
                  stops: [
                    0.0,
                    _shimmerController.value,
                    1.0,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(_isHovering ? 0.5 : 0.3),
                    blurRadius: _isHovering ? 20 : 10,
                    spreadRadius: _isHovering ? 2 : 0,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(2),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onPressed,
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "GO PREMIUM",
                            style: AppTheme.bebas(
                              size: 15,
                              color: Colors.amber,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// === FLOATING LOGIN BUTTON ===
class _FloatingLoginButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _FloatingLoginButton({required this.onPressed});

  @override
  State<_FloatingLoginButton> createState() => _FloatingLoginButtonState();
}

class _FloatingLoginButtonState extends State<_FloatingLoginButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: _isHovering
              ? LinearGradient(
            colors: [
              AppColors.vibrantPink,
              AppColors.vibrantPurple,
            ],
          )
              : null,
          color: _isHovering ? null : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovering
                ? Colors.transparent
                : Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: _isHovering
              ? [
            BoxShadow(
              color: AppColors.vibrantPink.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.login_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "LOGIN",
                    style: AppTheme.bebas(
                      size: 15,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// === MOBILE MENU SHEET ===
class _MobileMenuSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
            ),
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _MobileMenuItem(
                    icon: Icons.security_rounded,
                    title: "RED FLAG SCANNER",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                  ),
                  _MobileMenuItem(
                    icon: Icons.shield_outlined,
                    title: "SCAM RISK",
                    onTap: () => Navigator.pop(context),
                  ),
                  _MobileMenuItem(
                    icon: Icons.sports_esports_rounded,
                    title: "GAMES",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/game');
                    },
                  ),
                  const SizedBox(height: 16),
                  _FloatingPremiumButton(onPressed: () {}),
                  const SizedBox(height: 12),
                  _FloatingLoginButton(onPressed: () {}),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MobileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.vibrantPink),
      title: Text(
        title,
        style: AppTheme.bebas(size: 18, color: Colors.white),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      tileColor: Colors.white.withOpacity(0.05),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}