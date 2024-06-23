// ignore_for_file: depend_on_referenced_packages

library flutterap_event_calendar;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siz/Utils/Colors.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';
//Event calendar with the ability to move,drag , add and edit events

class MyCustomCalender extends StatefulWidget {
  // final void Function(CalendarTapDetails)? onTapCell;
  final void Function(Appointment)? onAddEvent;
  // final void Function(Appointment)? onEditEvent;
  // final void Function(List<Appointment>)? onDeleteEvent;
  final List<Appointment>? appointmentsList;
  // final void Function(CalendarLongPressDetails)? onLongPressCell;
  // final void Function(AppointmentDragUpdateDetails)? onDragUpdateCell;
  // final void Function(AppointmentDragEndDetails)? onDragEndCell;
  final void Function(ViewChangedDetails)? onViewChanged;
  final void Function(AppointmentResizeEndDetails)? onAppointmentResizeEndCell;
  final void Function(AppointmentResizeStartDetails)?
      onAppointmentResizeStartCell;
  final void Function(AppointmentResizeUpdateDetails)?
      onAppointmentResizeUpdateCell;
  // final void Function(AppointmentDragStartDetails)? onDragStartCell;
  final void Function(CalendarSelectionDetails)? onSelectionChangedCell;

  const MyCustomCalender({
    Key? key,
    this.onAddEvent,
    this.appointmentsList,
    this.onViewChanged,
    this.onAppointmentResizeEndCell,
    this.onAppointmentResizeStartCell,
    this.onAppointmentResizeUpdateCell,
    this.onSelectionChangedCell,
  }) : super(key: key);

  @override
  State<MyCustomCalender> createState() => _MyCustomCalenderState();
}

class _MyCustomCalenderState extends State<MyCustomCalender> {
  final List<Appointment> _appointments = <Appointment>[];
  final CalendarController _calendarController = CalendarController();
  final TextEditingController _editController = TextEditingController();

  late Appointment _draggedAppointment;
  late DateTime _newAppointmentDate;

  DateTime date = DateTime.now();
  DateTime dateAdd = DateTime.now();

  // ignore: prefer_final_fields
  DateTime dateEdit = DateTime.now();



  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 600,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child: SfCalendar(
        
        view: CalendarView.month,
        controller: _calendarController,
        dataSource: _getDataSource(),
        headerStyle:
             CalendarHeaderStyle(textStyle: GoogleFonts.lexendDeca(
              fontWeight: FontWeight.w300,
              color: Colors.black,
              fontSize: 16)),
        viewHeaderStyle: const ViewHeaderStyle(
          dayTextStyle: TextStyle(color: Colors.black, fontSize: 10),
        ),
        appointmentBuilder: _appointmentBuilder,
        cellEndPadding: 0,
        monthCellBuilder: _monthCellBuilder,
        todayTextStyle: const TextStyle(fontSize: 0),
        selectionDecoration: BoxDecoration(
          border: Border.all(
            color: MyColors.themecolor,
          ),
        ),
        monthViewSettings: const MonthViewSettings(
          showTrailingAndLeadingDates: false,
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        todayHighlightColor: const Color(0xff38BDF8),
        allowDragAndDrop: true,
        allowAppointmentResize: true,
        onTap: (detail) {
          setState(() {
            date = detail.date ?? DateTime.now();
            dateAdd = detail.date ?? DateTime.now();
          });
        },
        onDragEnd: (details) {
          _draggedAppointment.startTime =
              _newAppointmentDate.subtract(const Duration(hours: 1));
          _draggedAppointment.endTime = _newAppointmentDate;
          setState(() {});
          // widget.onDragEndCell!(details);
        },
        onViewChanged: (details) {
          widget.onViewChanged!(details);
        },
        onAppointmentResizeEnd: (details) {
          widget.onAppointmentResizeEndCell!(details);
        },
        onAppointmentResizeStart: (details) {
          widget.onAppointmentResizeStartCell!(details);
        },
        onAppointmentResizeUpdate: (details) {
          widget.onAppointmentResizeUpdateCell!(details);
        },
      ),
    );
  }

  Widget _appointmentBuilder(
      BuildContext context, CalendarAppointmentDetails details) {
    if (details.isMoreAppointmentRegion) {
      return SizedBox(
        width: details.bounds.width,
        height: details.bounds.height,
        child: InkWell(
          child:  Text(
            
            '+More',
            textAlign: TextAlign.center,
            style: GoogleFonts.lexendDeca(color:MyColors.themecolor, fontSize: 10,fontWeight:FontWeight.w300),
          ),
          onTap: () {
            _showMoreEvents(context, details);
          },
        ),
      );
    } else if (_calendarController.view == CalendarView.month) {
      final Appointment appointment = details.appointments.first;
      return InkWell(
        child: Container(
            width: details.bounds.width,
            height: details.bounds.height,
            decoration: BoxDecoration(
              color: appointment.color,
            ),
            alignment: Alignment.center,
            child: Text(
              appointment.subject,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:GoogleFonts.lexendDeca (color: Colors.black,fontWeight: FontWeight.w300, fontSize: 10),
            )),
        onTap: () {
          setState(() {
            date = details.date;
            _editController.text = details.appointments.first.subject;
          });

          // _editEvent(context, details.appointments.first.id);
        },
      );
    } else {
      final Appointment appointment = details.appointments.first;
      return SizedBox(
        width: details.bounds.width,
        height: details.bounds.height,
        child: InkWell(
          child: Text(
            appointment.subject,
            style: GoogleFonts.lexendDeca (color: Colors.black,fontWeight: FontWeight.w300, fontSize: 10),
          ),
          onTap: () {
            setState(() {
              date = details.date;
              _editController.text = details.appointments.first.subject;
            });

            // _editEvent(context, details.appointments.first.id);
          },
        ),
      );
    }
  }

  Widget _monthCellBuilder(BuildContext context, MonthCellDetails details) {
    return Container(
      decoration: BoxDecoration(
        color: (details.date.day == DateTime.now().day &&
                details.date.month == DateTime.now().month)
            ? const Color.fromARGB(255, 172, 172, 172)
            : Colors.transparent,
        border: Border.all(
          color: const Color(0xffE4E6E8),
        ),
      ),
      child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            details.date.day.toString(),
            style: TextStyle(
                fontSize: 10,
                color: details.date.month == DateTime.now().month
                    ? Colors.black
                    : Colors.black54),
          )),
    );
  }

  _DataSource _getDataSource() {
    return _DataSource(widget.appointmentsList ?? _appointments);
  }

  //Show More Events
  Future<dynamic> _showMoreEvents(
      BuildContext context, CalendarAppointmentDetails details) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          actions: <Widget>[
            SizedBox(
              height: 400,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                     Text(
                      "MY ORDERS",
                      style: GoogleFonts.lexendDeca(
                        fontWeight: FontWeight.w300
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ...List.generate(details.appointments.length, (index) {
                      final Appointment appointment =
                          details.appointments.elementAt(index);
                      return Column(
                        children: [
                          InkWell(
                            child: Container(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                alignment: Alignment.center,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: appointment.color,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  appointment.subject,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lexendDeca (
                                    fontWeight: FontWeight.w300,
                                    fontSize: 10,
                                    color: Colors.black,
                                  ),
                                )),
                            onTap: () {
                              setState(() {
                                // _date = details.date;
                                // _editController.text =
                                //     details.appointments.first.subject;
                              });

                              // _editEvent(context, details.appointments.first.id);
                            },
                          ),
                          const SizedBox(height: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${appointment.startTime.day}/${appointment.startTime.month}/${appointment.startTime.year}",
                                style: const TextStyle(
                                    fontSize: 11, color: Colors.grey),
                              ),
                              const Text(
                                "TO",
                                style:
                                    TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                              Text(
                                "${appointment.endTime.day}/${appointment.endTime.month}/${appointment.endTime.year}",
                                style: const TextStyle(
                                    fontSize: 11, color: Colors.grey),
                              )
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                bottom: 10, top: 5, left: 20, right: 20),
                            width: MediaQuery.of(context).size.width,
                            height: 1,
                            color: const Color.fromARGB(255, 204, 204, 204),
                          )
                        ],
                      );
                    })
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
