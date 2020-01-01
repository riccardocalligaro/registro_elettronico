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
        description:
            "This is a quick intro of the application while we are downloading data from Spaggiari",
        backgroundColor: Colors.indigo,
      ),
    );
    slides.add(
      new Slide(
        title: "PENCIL",
        description:
            "Ye indulgence unreserved connection alteration appearance",
        backgroundColor: Color(0xff203152),
      ),
    );
    slides.add(
      new Slide(
        title: "RULER",
        description:
            "Much evil soon high in hope do view. Out may few northward believing attempted. Yet timed being songs marry one defer men our. Although finished blessing do of",
        backgroundColor: Color(0xff9932CC),
      ),
    );
    slides.add(
      new Slide(
        title: "DOWNLOADING...",
        centerWidget: BlocBuilder<IntroBloc, IntroState>(
          builder: (context, state) {
            if (state is IntroLoading) {
              return CircularPercentIndicator(
                radius: 240,
                lineWidth: 10,
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
        backgroundColor: Color(0xff9932CC),
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
