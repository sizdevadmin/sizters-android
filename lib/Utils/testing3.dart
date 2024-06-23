import 'package:cr_calendar/cr_calendar.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  CrCalendarController calendarController = CrCalendarController(events: [
    CalendarEventModel(
        name: "Rent gucci clothes",
        begin: DateTime.now(),
        end: DateTime.now().add(const Duration(days: 10)))
  ]);

  int currentMonth = 0;

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                  left: 10, right: 10, top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {
                        calendarController.swipeToPreviousPage();
                        currentMonth = calendarController.date.month;

                        setState(() {});
                      },
                      child: const Icon(Icons.arrow_left)),

                  // month text
                  Text(currentMonth == 1
                      ? 'January'
                      : currentMonth == 2
                          ? "February"
                          : currentMonth == 3
                              ? "March"
                              : currentMonth == 4
                                  ? "April"
                                  : currentMonth == 5
                                      ? "May"
                                      : currentMonth == 6
                                          ? "June"
                                          : currentMonth == 7
                                              ? "July"
                                              : currentMonth == 8
                                                  ? "August"
                                                  : currentMonth == 9
                                                      ? "September"
                                                      : currentMonth == 10
                                                          ? "October"
                                                          : currentMonth == 11
                                                              ? "November"
                                                              : currentMonth ==
                                                                      12
                                                                  ? "December"
                                                                  : ""),

                  InkWell(
                      onTap: () {
                        calendarController.swipeToNextMonth();
                        currentMonth = calendarController.date.month;

                        setState(() {});
                      },
                      child: const Icon(Icons.arrow_right)),
                ],
              ),
            ),
            SizedBox(
              height: 600,
              child: CrCalendar(
               
                eventsTopPadding: 20,
                onSwipeCallbackDebounceMs: 0,
                minDate: DateTime.now(),
                initialDate: DateTime.now(),
                controller: calendarController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
