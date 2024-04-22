package scheduler.model;

import scheduler.db.ConnectionManager;
import scheduler.util.Util;

import java.sql.*;
import java.util.Arrays;
import java.util.UUID;

public class Appointment {
    private final String appointmentID;
    private String careGiverName;
    private Date date;
    private String patientName;

    private Appointment(Appointment.AppointmentBuilder builder) {
        this.appointmentID = builder.appointmentID;
        this.careGiverName = builder.careGiverName;
        this.date = builder.date;
        this.patientName = builder.patientName;
    }

    private Appointment(Appointment.AppointmentGetter getter) {
        this.appointmentID = getter.appointmentID;
    }

    // Getters
    public String getAppointmentID() {
        return appointmentID;
    }

    public void saveToDB(String vaccineName) throws SQLException {
        ConnectionManager cm = new ConnectionManager();
        Connection con = cm.createConnection();

        String addAppointment = "INSERT INTO Appointments VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement statement = con.prepareStatement(addAppointment);
            statement.setString(1, this.appointmentID);
            statement.setString(2, String.valueOf(this.date));
            statement.setString(3, vaccineName);
            statement.setString(4, this.careGiverName);
            statement.setString(5, this.patientName);
            statement.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            throw new SQLException();
        } finally {
            cm.closeConnection();
        }
    }


    public static class AppointmentBuilder {
        private final String appointmentID;
        private String careGiverName;
        private Date date;
        private String patientName;
        public AppointmentBuilder(String assignedCaregiver, Date d, String assignedPatient) {
            UUID randomUUID = UUID.randomUUID();
            String randomString = randomUUID.toString().replaceAll("_", "");
            this.appointmentID = randomString;
            this.careGiverName = assignedCaregiver;
            this.date = d;
            this.patientName = assignedPatient;
        }

        public Appointment build() {
            return new Appointment(this);
        }
    }

    public static class AppointmentGetter {
        private final String appointmentID;
        private String careGiverName;

        public AppointmentGetter(String appointmentID) {
            this.appointmentID = appointmentID;
        }

        public Appointment get() throws SQLException {
            ConnectionManager cm = new ConnectionManager();
            Connection con = cm.createConnection();

            String getAppointment = "SELECT ID FROM Appointments WHERE ID = ?";
            try {
                PreparedStatement statement = con.prepareStatement(getAppointment);
                statement.setString(1, this.appointmentID);
                ResultSet resultSet = statement.executeQuery();
                while (resultSet.next()) {
                    this.careGiverName = resultSet.getString("Username");
                    return new Appointment(this);
                }
                return null;
            } catch (SQLException e) {
                throw new SQLException();
            } finally {
                cm.closeConnection();
            }
        }
    }

}
