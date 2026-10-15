import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Demo Vídeo',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const VideoTela(),
    );
  }
}

class VideoTela extends StatefulWidget {
  const VideoTela({super.key});

  @override
  State<VideoTela> createState() => _VideoTelaState();
}

class _VideoTelaState extends State<VideoTela> {
  late VideoPlayerController _controller;
  bool _estaCarregado = false;
  String? _mensagemErro;

  @override
  void initState() {
    super.initState();

    _controller =
        VideoPlayerController.networkUrl(
            Uri.parse(
              'https://raw.githubusercontent.com/luisantonioju/app_video_player/main/video.mp4',
            ),
          )
          ..initialize()
              .then((_) {
                setState(() {
                  _estaCarregado = true;
                });
              })
              .catchError((error) {
                setState(() {
                  _mensagemErro = "Erro ao carregar o vídeo: $error";
                });
              });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _alternarPlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UC14 - Tocar um Vídeo')),
      // Usamos SingleChildScrollView para evitar o erro de overflow nas bordas
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_mensagemErro != null)
                Text(
                  _mensagemErro!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                )
              else
                _estaCarregado
                    ? SizedBox(
                        // Limitamos a altura máxima do vídeo para caber na tela do emulador
                        height: 350,
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.all(50.0),
                        child: CircularProgressIndicator(),
                      ),
              const SizedBox(height: 24),
              Text(
                _estaCarregado && _controller.value.isPlaying
                    ? 'Status: Tocando vídeo 🎬'
                    : 'Status: Pausado ⏸️',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _estaCarregado ? _alternarPlayPause : null,
                icon: Icon(
                  _estaCarregado && _controller.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
                label: Text(
                  _estaCarregado && _controller.value.isPlaying
                      ? 'Pausar'
                      : 'Tocar Vídeo',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
