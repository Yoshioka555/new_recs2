import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../header_footer_drawer/drawer.dart';

class EventIndexPage extends StatefulWidget {
  /// Creates the home page to display teh calendar widget.
  const EventIndexPage({Key? key}) : super(key: key);


  @override
  _EventIndexPageState createState() => _EventIndexPageState();
}


class _EventIndexPageState extends State<EventIndexPage> {
  final CalendarController _controller = CalendarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  icon: const Icon(Icons.timer),
                  onPressed: () async {

                  }
              ),
            ),
          ],
          backgroundColor: Colors.purple[200],
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          centerTitle: true,
          elevation: 0.0,
          title: const Text('イベントページ',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        drawer: const UserDrawer(),
        body: SafeArea(
            child: SfCalendar(
              dataSource: MeetingDataSource(_getDataSource()),
              view: CalendarView.month,
              controller: _controller,
              cellEndPadding: 0,
              allowedViews: const <CalendarView>[
                CalendarView.day,
                CalendarView.week,
                CalendarView.workWeek,
                CalendarView.month,
                CalendarView.timelineDay,
                CalendarView.timelineWeek,
                CalendarView.timelineWorkWeek,
                CalendarView.timelineMonth,
                CalendarView.schedule
              ],
              appointmentBuilder: (BuildContext context, CalendarAppointmentDetails details) {
                final Meeting appointment = details.appointments.first;
                final bool isTimeslotAppointment = _isTimeslotAppointmentView(appointment, _controller.view);
                final bool isStartAppointment = !isTimeslotAppointment && _isStartOfAppointmentView(appointment, details.date);
                final bool isEndAppointment = !isTimeslotAppointment && _isEndOfAppointmentView( appointment, details.date, _controller.view);
                return Container(
                  margin: EdgeInsets.fromLTRB(isStartAppointment ? 0 : 0, 0, isEndAppointment ? 0 : 0, 0),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  color: appointment.background,
                  child: Text(appointment.eventName,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
               );
              },
              monthViewSettings: const MonthViewSettings(
                  appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
            ),
        ),
    );
  }


  /// Check whether the appointment placed inside the timeslot on day, week
  /// and work week views.
  bool _isTimeslotAppointmentView(Meeting app, CalendarView? view) {
    return (view == CalendarView.day ||
        view == CalendarView.week ||
        view == CalendarView.workWeek) &&
        app.to.difference(app.from).inDays < 1;
  }
  /// Check the date values are equal based on day, month and year.
  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
  /// Check the appointment view is start of an appointment.
  bool _isStartOfAppointmentView(Meeting app, DateTime date) {
    return _isSameDate(app.from, date);
  }
  /// Check the appointment view is end of an appointment.
  bool _isEndOfAppointmentView(Meeting app, DateTime date, CalendarView? view) {
    if (view == CalendarView.month ||
        view == CalendarView.timelineWeek ||
        view == CalendarView.timelineWorkWeek ||
        view == CalendarView.week ||
        view == CalendarView.workWeek) {
      const int firstDayOfWeek = DateTime.sunday; // denotes the sunday weekday.

      /// Calculate the start date of the current week based on the builder
      /// date and first day of week.
      int value = -date.weekday + firstDayOfWeek - DateTime.daysPerWeek;
      if (value.abs() >= DateTime.daysPerWeek) {
        value += DateTime.daysPerWeek;
      }

      /// Current week start date.
      final DateTime weekStartDate = date.add(Duration(days: value));
      DateTime weekEndDate = weekStartDate.add(const Duration(days: DateTime.daysPerWeek - 1));
      weekEndDate = DateTime(weekEndDate.year, weekEndDate.month, weekEndDate.day, 23, 59, 59);

      /// Check the appointment end date is on or before the week end date.
      return weekEndDate.isAfter(app.to) || _isSameDate(app.to, weekEndDate);
    } else if (view == CalendarView.schedule || view == CalendarView.timelineDay || view == CalendarView.day) {
      /// In calendar day, timeline day and schedule views
      /// are rendered based on each day, so we need to check the builder
      /// date value with appointment end date value for identify
      /// the end of the appointment.
      return _isSameDate(app.to, date);
    } else if (view == CalendarView.timelineMonth) {
      /// In calendar timeline month view render based month value so we need
      /// to check the builder date month and year value with appointment end
      /// date month and year value for identify the end of the appointment.
      return app.to.month == date.month && app.to.year == date.year;
    }
    return false;
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime a = DateTime(2024, 5,20);
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
    final DateTime endTime = startTime.add(const Duration(days: 6));
    meetings.add(Meeting(
        'Conference', startTime, endTime, const Color(0xFF0F8644), false));
    meetings.add(Meeting('Conference1', startTime,
        startTime.add(const Duration(hours: 20)), Colors.blue, false));
    meetings.add(Meeting('Conference2', startTime,
        startTime.add(const Duration(days: 20)), Colors.red, false));
    meetings.add(Meeting('Event', a, a, Colors.teal, false));
    return meetings;
  }
}


/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }


  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }


  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }


  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }


  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }


  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }


  @override
  Object? convertAppointmentToObject(
      Object? customData, Appointment appointment) {
    return Meeting(appointment.subject, appointment.startTime,
        appointment.endTime, appointment.color, appointment.isAllDay);
  }


  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }


    return meetingData;
  }
}


/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);


  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;


  /// From which is equivalent to start time property of [Appointment].
  DateTime from;


  /// To which is equivalent to end time property of [Appointment].
  DateTime to;


  /// Background which is equivalent to color property of [Appointment].
  Color background;


  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
