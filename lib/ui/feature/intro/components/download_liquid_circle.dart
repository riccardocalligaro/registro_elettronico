import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:registro_elettronico/ui/bloc/intro/bloc.dart';

class IntroDownloadLiquidCircle extends StatefulWidget {
  IntroDownloadLiquidCircle({Key key}) : super(key: key);

  @override
  _IntroDownloadLiquidCircleState createState() =>
      _IntroDownloadLiquidCircleState();
}

class _IntroDownloadLiquidCircleState extends State<IntroDownloadLiquidCircle>
    with SingleTickerProviderStateMixin {
  double value = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        BlocBuilder<IntroBloc, IntroState>(
          builder: (context, state) {
            if (state is IntroLoading) {
              return Container(
                height: 300,
                width: 300,
                child: LiquidCircularProgressIndicator(
                  value: state.progress / 100,
                  valueColor: AlwaysStoppedAnimation(Colors.red),
                  backgroundColor: Colors
                      .white, // Defaults to the current Theme's backgroundColor.
                ),
              );
            }
            if (state is IntroLoaded || state is IntroInitial) {
              return Container(
                height: 300,
                width: 300,
                child: GestureDetector(
                  onTap: () {},
                  child: LiquidCircularProgressIndicator(
                    value: 1.0,
                    valueColor: AlwaysStoppedAnimation(Colors.green),
                    backgroundColor: Colors.white,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.check,
                          size: 84,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Press here',
                          style: TextStyle(fontSize: 24),
                        )
                      ],
                    ), // Defaults to the current Theme's backgroundColor.
                  ),
                ),
              );
            }
            return Container(
              height: 300,
              width: 300,
              child: LiquidCircularProgressIndicator(
                value: 0.0,
                valueColor: AlwaysStoppedAnimation(Colors.red),
                backgroundColor: Colors
                    .white, // Defaults to the current Theme's backgroundColor.
              ),
            );
          },
        ),
        // RaisedButton(
        //   child: Text('increment'),
        //   onPressed: () {
        //     BlocProvider.of<IntroBloc>(context).add(FetchAllData());
        //   },
        // )
      ],
    );
  }
}
