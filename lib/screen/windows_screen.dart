import 'package:flutter/material.dart';
import 'package:merterim_dev_cv_app/models/theme.dart';
import 'package:provider/provider.dart';

class WindowsScreen extends StatefulWidget {
  final Widget child;
  const WindowsScreen({super.key, required this.child});

  @override
  State<WindowsScreen> createState() => _WindowsScreenState();
}

enum ResizePosition { topLeft, topRight, bottomLeft, bottomRight }

class _WindowsScreenState extends State<WindowsScreen> {
  bool _isStartUpMenuOpen = false;
  bool _isWindowsElements = false;
  bool _isResizing = false;
  ResizePosition _resizePosition = ResizePosition.bottomRight;
  String? windowsElementTitle;
  ImageProvider? windowsElementImage;
  double _x = 40;
  double _y = 40;
  Size _size = const Size(1200, 600);

  bool checkCursorPositions(double x, double y) {
    if ((x >= 0 && x <= 8 && y >= 0 && y <= 8)) {
      setState(() {
        _resizePosition = ResizePosition.topLeft;
      });

      return true;
    } else if (y >= 0 && y <= 8 && x >= _size.width - 8 && x <= _size.width) {
      setState(() {
        _resizePosition = ResizePosition.topRight;
      });
      return true;
    } else if ((x >= 0 && x <= 56 && y >= 0 && y <= 48)) {
      setState(() {
        _resizePosition = ResizePosition.bottomLeft;
      });
      return true;
    } else if ((x >= 0 && x <= 56 && y >= 0 && y <= 48)) {
      setState(() {
        _resizePosition = ResizePosition.bottomRight;
      });

      return true;
    }
    return false;
  }

  void clickWindowsLogo() {
    setState(() {
      _isStartUpMenuOpen = !_isStartUpMenuOpen;
    });
  }

  void openWindowsElement(
    String? title,
    ImageProvider? image,
  ) {
    setState(() {
      _isWindowsElements = true;
      windowsElementTitle = title;
      windowsElementImage = image;
      if (_isStartUpMenuOpen) {
        _isStartUpMenuOpen = false;
      }
    });
  }

  void closeWindowsElement() {
    setState(() {
      _isWindowsElements = false;
      windowsElementTitle = null;
      windowsElementImage = null;
    });
  }

  void onResize(DragUpdateDetails details) {
    switch (_resizePosition) {
      case ResizePosition.topLeft:
        setState(() {
          _x += details.delta.dx;
          _y += details.delta.dy;
          final width = _size.width + (details.delta.dx * -1);
          final height = _size.height + (details.delta.dy * -1);
          _size = Size(width, height);
        });
        break;
      case ResizePosition.topRight:
        setState(() {
          final width = _size.width + details.delta.dx;
          final height = _size.height + (details.delta.dy * -1);

          if (width == 450 || height == 400) {
            setState(() {
              _isResizing = false;

              return;
            });
          }
          _size = Size(width, height);
          _y += details.delta.dy;
        });

        break;
      case ResizePosition.bottomLeft:
        setState(() {
          _x += details.delta.dx;
          _y += details.delta.dy;
        });
        break;
      case ResizePosition.bottomRight:
        setState(() {
          _x += details.delta.dx;
          _y += details.delta.dy;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeModel>();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  'assets/images/w11-${theme.getCurrentTheme == Brightness.dark ? 'dark' : 'light'}.jpg'),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            Expanded(
                child: Stack(
              children: [
                widget.child,
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    width: double.infinity,
                    height: 500,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WindowsDesktopElement(
                          title: 'Bu bilgisayar',
                          image: const AssetImage(
                              'assets/w11/Personalization.png'),
                          onTap: () => openWindowsElement(
                              'Bu bilgisayar',
                              const AssetImage(
                                  'assets/w11/Personalization.png')),
                        ),
                        WindowsDesktopElement(
                          title: 'Çöp Kutusu',
                          image: const AssetImage('assets/w11/trashEmpty.png'),
                          onTap: () => openWindowsElement('Çöp Kutusu',
                              const AssetImage('assets/w11/trashEmpty.png')),
                        ),
                        WindowsDesktopElement(
                          title: 'Ayarlar',
                          image: const AssetImage('assets/w11/Settings.png'),
                          onTap: () => openWindowsElement('Ayarlar',
                              const AssetImage('assets/w11/Settings.png')),
                        ),
                        WindowsDesktopElement(
                          title: 'Mert Erim CV',
                          image: const AssetImage('assets/w11/pdf.png'),
                          onTap: () => openWindowsElement('Mert Erim CV',
                              const AssetImage('assets/w11/pdf.png')),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_isWindowsElements)
                  Positioned(
                    top: _y,
                    left: _x,
                    child: GestureDetector(
                      onPanEnd: (details) {
                        if (_isResizing) {
                          setState(() {
                            _isResizing = false;
                          });
                          return;
                        }
                      },
                      onPanUpdate: (details) {
                        if (checkCursorPositions(details.localPosition.dx,
                                details.localPosition.dy) &&
                            _isResizing == false) {
                          setState(() {
                            _isResizing = true;
                          });
                        }

                        if (_isResizing) {
                          onResize(details);
                          return;
                        }
                        setState(() {
                          _x += details.delta.dx;
                          _y += details.delta.dy;
                        });
                      },
                      child: ExpolererWidget(
                        title: windowsElementTitle!,
                        image: windowsElementImage!,
                        closeWindowsElement: closeWindowsElement,
                        size: _size,
                      ),
                    ),
                  ),
                if (_isStartUpMenuOpen)
                  const Positioned(
                    bottom: 4,
                    left: 16,
                    child: StartUpMenu(),
                  ),
              ],
            )),
            SizedBox(
              height: 48,
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.95),
                      Colors.black.withOpacity(0.9),
                      Colors.black.withOpacity(.95)
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Material(
                      borderRadius: BorderRadius.circular(4),
                      color: _isStartUpMenuOpen
                          ? Colors.white.withOpacity(0.1)
                          : Colors.transparent,
                      child: Tooltip(
                        message: 'Başlat',
                        child: InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          onTap: clickWindowsLogo,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/windows_logo.png',
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class StartUpMenu extends StatelessWidget {
  const StartUpMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 480,
      height: 520,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color.fromARGB(255, 26, 21, 19)),
      child: Column(
        children: [
          const Spacer(),
          Container(
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              color: Colors.black.withOpacity(0.8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 32),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            child: Icon(Icons.person, size: 20),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Mert Erim',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.power_settings_new,
                          size: 24, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WindowsDesktopElement extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  final ImageProvider image;
  const WindowsDesktopElement(
      {super.key, required this.title, this.onTap, required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 56,
              height: 56,
              child: Column(
                children: [
                  Image(image: image, width: 32, height: 32),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w500),
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

class ExpolererWidget extends StatelessWidget {
  final void Function()? closeWindowsElement;

  final String title;
  final ImageProvider image;
  final Size size;
  const ExpolererWidget({
    super.key,
    required this.title,
    required this.image,
    this.closeWindowsElement,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color.fromARGB(255, 26, 21, 19)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              height: 4,
              width: double.infinity,
              child: Row(
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.resizeUpLeft,
                    child: GestureDetector(
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        width: 8,
                        height: 8,
                      ),
                    ),
                  ),
                  const Spacer(),
                  MouseRegion(
                    cursor: SystemMouseCursors.resizeUpRight,
                    child: GestureDetector(
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        width: 8,
                        height: 8,
                      ),
                    ),
                  ),
                ],
              )),
          Row(
            children: [
              const SizedBox(width: 16),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(138, 48, 39, 35),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    width: 200,
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Material(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.transparent,
                          child: InkWell(
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onTap: () {},
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Image(image: image, width: 24, height: 24)),
                          ),
                        ),
                        Text(
                          title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    )),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  height: 48,
                  child: Row(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(Icons.remove,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  size: 24),
                            )),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.crop_square,
                              size: 24,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: closeWindowsElement,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.close,
                              size: 24,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          Container(
            width: double.infinity,
            height: 40,
            color: const Color.fromARGB(138, 48, 39, 35),
            child: const Row(
              children: [
                SizedBox(width: 16),
                Text(
                  'Dosya',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                print("tıklandı");
              },
              child: GestureDetector(
                onPanUpdate: (details) {},
                onPanCancel: () {},
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: const Color.fromARGB(138, 48, 39, 35),
                  child: const Center(
                    child: Text(
                      'Mert Erim CV',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
