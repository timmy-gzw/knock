import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gif/gif.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KnockPage extends StatefulWidget {
  const KnockPage({super.key});

  @override
  State<KnockPage> createState() => _KnockPageState();
}

class _KnockPageState extends State<KnockPage> with TickerProviderStateMixin {
  late final GifController _gifController;
  late final AudioPlayer _player;
  bool start = false;
  int count = 0;

  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  late SharedPreferences _preferences;

  @override
  void initState() {
    super.initState();
    _gifController = GifController(vsync: this);
    playMusic();
    _initAnimation();
    _initSharedPreferences();
  }

  void _initSharedPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    var splashOpen = _preferences.getBool("splash_open") ?? false;
    if (!splashOpen) {
      _preferences.setBool("splash_open", true);
      // 显示toast，恭喜百天
      Fluttertoast.showToast(
          msg: "提前祝-蓝羡-百天快乐，慢慢敲吧～",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    setState(() {
      count = _preferences.getInt("knock_count") ?? 0;
    });
  }

  void playMusic() async {
    _player = AudioPlayer();
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setSource(AssetSource('mp3/fish_sound.mp3'));
  }

  void _initAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reset();
          _animationController.forward();
          setState(() {
            count++;
            _preferences.setInt("knock_count", count);
          });
        }
      });
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.5),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/svg/icon.svg",
                      width: 30,
                      height: 30,
                      colorFilter:
                          const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                    ),
                    Text("$count")
                  ],
                ),
              ),
              Stack(
                children: [
                  Gif(
                    width: 300,
                    height: 300,
                    controller: _gifController,
                    duration: const Duration(milliseconds: 550),
                    autostart: Autostart.no,
                    placeholder: (context) =>
                        const Center(child: CircularProgressIndicator()),
                    image: const AssetImage('assets/gif/amination.gif'),
                  ),
                  SlideTransition(
                    position: _offsetAnimation,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: Container(
                        margin: const EdgeInsets.only(top: 50, left: 50),
                        child: const Text(
                          '+1',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              start
                  ? IconButton(
                      onPressed: () {
                        _gifController.stop();
                        _player.pause();
                        _animationController.stop();
                        setState(() {
                          start = !start;
                        });
                      },
                      icon: Image.asset('assets/image/pause.png'))
                  : IconButton(
                      onPressed: () {
                        _gifController.reset();
                        _gifController.repeat();
                        _player.resume();

                        _animationController.reset();
                        _animationController.forward();

                        _player.play(AssetSource('mp3/fish_sound.mp3'));
                        setState(() {
                          start = !start;
                        });
                      },
                      icon: Image.asset('assets/image/start.png')),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _gifController.dispose();
    _player.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
