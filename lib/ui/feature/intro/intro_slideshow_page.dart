import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:registro_elettronico/component/navigator.dart';
import 'package:registro_elettronico/ui/bloc/intro/bloc.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';

class IntroSlideshowPage extends StatefulWidget {
  IntroSlideshowPage({Key key}) : super(key: key);

  @override
  _IntroSlideshowPageState createState() => _IntroSlideshowPageState();
}

class _IntroSlideshowPageState extends State<IntroSlideshowPage> {
  List<Slide> slides = new List();
  bool _downloadDataFinished = false;

  _addSlides() {
    slides.add(
      new Slide(
        title: "REGISTRO ELETTRONICO",
        maxLineTitle: 2,
        centerWidget: Padding(
          padding: const EdgeInsets.symmetric(vertical: 81),
          child: Icon(
            Icons.school,
            size: 80,
            color: Colors.red,
          ),
        ),
        description:
            "This is a quick intro of the application while we are downloading data from Spaggiari",
        backgroundColor: Colors.grey[900],
      ),
    );
    slides.add(
      new Slide(
        title: "GRADES",
        centerWidget: Padding(
          padding: const EdgeInsets.symmetric(vertical: 100),
          child: Icon(
            Icons.timeline,
            size: 80,
            color: Colors.red,
          ),
        ),
        description:
            "The app provides amazing graphs and stats about your school grades",
        backgroundColor: Colors.grey[900],
      ),
    );
    slides.add(
      new Slide(
        title: "DOWNLOAD",
        centerWidget: BlocBuilder<IntroBloc, IntroState>(
          builder: (context, state) {
            if (state is IntroLoading) {
              return CircularPercentIndicator(
                radius: 240,
                lineWidth: 10,
                center: Text('${state.progress}%'),
                percent: state.progress / 100,
              );
            }
            if (state is IntroLoaded) {
              _downloadDataFinished = true;
              return CircularPercentIndicator(
                radius: 240,
                animation: true,
                animationDuration: 500,
                lineWidth: 10,
                percent: 1.0,
                center: Text('OK!'),
              );
            }

            if (state is IntroError) {
              return CustomPlaceHolder(
                text: 'Error',
                icon: Icons.error,
                showUpdate: true,
                onTap: () {},
              );
            }

            return Container();
          },
        ),
        backgroundColor: Colors.grey[900],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _addSlides();
    //GlobalUtils.initialFetch(context);
  }

  void onDonePress() {
    _downloadDataFinished
        ? AppNavigator.instance.navToHome(context)
        : BlocProvider.of<IntroBloc>(context).add(FetchAllData());
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      isShowDotIndicator: true,
      slides: this.slides,
      onDonePress: this.onDonePress,
      isShowSkipBtn: false,
    );
  }
}
