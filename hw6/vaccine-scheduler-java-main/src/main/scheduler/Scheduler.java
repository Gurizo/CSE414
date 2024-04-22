package scheduler;

import scheduler.db.ConnectionManager;
import scheduler.model.Appointment;
import scheduler.model.Caregiver;
import scheduler.model.Patient;
import scheduler.model.Vaccine;
import scheduler.util.Util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.*;
import java.util.Map;
import java.util.TreeMap;
import java.util.TreeSet;

public class Scheduler {

    // objects to keep track of the currently logged-in user
    // Note: it is always true that at most one of currentCaregiver and currentPatient is not null
    //       since only one user can be logged-in at a time
    private static Caregiver currentCaregiver = null;
    private static Patient currentPatient = null;

    public static void main(String[] args) {
        // printing greetings text
        System.out.println();
        System.out.println("Welcome to the COVID-19 Vaccine Reservation Scheduling Application!");
        System.out.println("*** Please enter one of the following commands ***");
        System.out.println("> create_patient <username> <password>");  //TODO: implement create_patient (Part 1)
        System.out.println("> create_caregiver <username> <password>");
        System.out.println("> login_patient <username> <password>");  // TODO: implement login_patient (Part 1)
        System.out.println("> login_caregiver <username> <password>");
        System.out.println("> search_caregiver_schedule <date>");  // TODO: implement search_caregiver_schedule (Part 2)
        System.out.println("> reserve <date> <vaccine>");  // TODO: implement reserve (Part 2)
        System.out.println("> upload_availability <date>");
        System.out.println("> cancel <appointment_id>");  // TODO: implement cancel (extra credit)
        System.out.println("> add_doses <vaccine> <number>");
        System.out.println("> show_appointments");  // TODO: implement show_appointments (Part 2)
        System.out.println("> logout");  // TODO: implement logout (Part 2)
        System.out.println("> quit");
        System.out.println();

        // read input from user
        BufferedReader r = new BufferedReader(new InputStreamReader(System.in));
        while (true) {
            System.out.print("> ");
            String response = "";
            try {
                response = r.readLine();
            } catch (IOException e) {
                System.out.println("Please try again!");
            }
            // split the user input by spaces
            String[] tokens = response.split(" ");
            // check if input exists
            if (tokens.length == 0) {
                System.out.println("Please try again!");
                continue;
            }
            // determine which operation to perform
            String operation = tokens[0];
            if (operation.equals("create_patient")) {
                createPatient(tokens);
            } else if (operation.equals("create_caregiver")) {
                createCaregiver(tokens);
            } else if (operation.equals("login_patient")) {
                loginPatient(tokens);
            } else if (operation.equals("login_caregiver")) {
                loginCaregiver(tokens);
            } else if (operation.equals("search_caregiver_schedule")) {
                searchCaregiverSchedule(tokens);
            } else if (operation.equals("reserve")) {
                reserve(tokens);
            } else if (operation.equals("upload_availability")) {
                uploadAvailability(tokens);
            } else if (operation.equals("cancel")) {
                cancel(tokens);
            } else if (operation.equals("add_doses")) {
                addDoses(tokens);
            } else if (operation.equals("show_appointments")) {
                showAppointments(tokens);
            } else if (operation.equals("logout")) {
                logout(tokens);
            } else if (operation.equals("quit")) {
                System.out.println("Bye!");
                return;
            } else {
                System.out.println("Invalid operation name!");
            }
        }
    }

    private static void createPatient(String[] tokens) {
        // create_patient <username> <password>
        // check 1: the length for tokens needs to be exactly 3 to include all information (with the operation name)
        if (tokens.length != 3) {
            System.out.println("Failed to create user.");
            return;
        }
        String username = tokens[1];
        String password = tokens[2];

        // Password strength check
        if (!isPasswordStrong(password)) {
            System.out.println("Password does not meet the strength requirements.");
            System.out.println("Password should have at least 8 characters, a mixture of uppercase and lowercase letters, numbers, and include at least one special character from \"!\", \"@\", \"#\", or \"?\".");
            return;
        }

        // check 2: check if the username has been taken already
        if (usernameExistsPatient(username)) {
            System.out.println("Username taken, try again!");
            return;
        }

        byte[] salt = Util.generateSalt();
        byte[] hash = Util.generateHash(password, salt);

        // create the patient
        try {
            Patient patient = new Patient.PatientBuilder(username, salt, hash).build();
            // save the patient information to our database
            patient.saveToDB();
            System.out.println("Created user " + username);
        } catch (SQLException e) {
            System.out.println("Failed to create user.");
            e.printStackTrace();
        }
    }

    private static void createCaregiver(String[] tokens) {
        // create_caregiver <username> <password>
        // check 1: the length for tokens needs to be exactly 3 to include all information (with the operation name)
        if (tokens.length != 3) {
            System.out.println("Failed to create user.");
            return;
        }
        String username = tokens[1];
        String password = tokens[2];

        // Password strength check
        if (!isPasswordStrong(password)) {
            System.out.println("Password does not meet the strength requirements.");
            System.out.println("Password should have at least 8 characters, a mixture of uppercase and lowercase letters, numbers, and include at least one special character from \"!\", \"@\", \"#\", or \"?\".");
            return;
        }

        // check 2: check if the username has been taken already
        if (usernameExistsCaregiver(username)) {
            System.out.println("Username taken, try again!");
            return;
        }

        byte[] salt = Util.generateSalt();
        byte[] hash = Util.generateHash(password, salt);

        // create the caregiver
        try {
            Caregiver caregiver = new Caregiver.CaregiverBuilder(username, salt, hash).build();
            // save the caregiver information to our database
            caregiver.saveToDB();
            System.out.println("Created user " + username);
        } catch (SQLException e) {
            System.out.println("Failed to create user.");
            e.printStackTrace();
        }
    }

    private static boolean isPasswordStrong(String password) {
        // Password strength requirements
        String pattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@#?!]).{8,}$";

        return password.matches(pattern);
    }


    private static void uploadReserve(String appointmentID) throws SQLException { //patient name, appointment id
        ConnectionManager cm = new ConnectionManager();
        Connection con = cm.createConnection();

        String addIsCheckedBy = "INSERT INTO Reserves VALUES (? , ?)";
        try {
            PreparedStatement statement = con.prepareStatement(addIsCheckedBy);
            statement.setString(1, currentPatient.getUsername());
            statement.setString(2, appointmentID);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException();
        } finally {
            cm.closeConnection();
        }
    }

    private static void createAppointment(Date d, String assignedCaregiver, String vaccineName) {
        try {
            Appointment appointment = new Appointment.AppointmentBuilder(assignedCaregiver, d, currentPatient.getUsername()).build();
            String appointmentID = appointment.getAppointmentID();
            // save an appointment information to our database
            appointment.saveToDB(vaccineName);
            uploadReserve(appointmentID);
            System.out.println("Created an appointment");
            removeAvailability(d, assignedCaregiver); //remove availability for assigned caregiver
            Vaccine vaccine = new Vaccine.VaccineGetter(vaccineName).get();
            vaccine.decreaseAvailableDoses(1);
            System.out.println("Appointment ID: "+ appointment.getAppointmentID()+ ", Caregiver username: " + assignedCaregiver);
        } catch (SQLException e) {
            System.out.println("Failed to create an appointment.");
            e.printStackTrace();
        }
    }

    private static boolean usernameExistsPatient(String username) {
        ConnectionManager cm = new ConnectionManager();
        Connection con = cm.createConnection();

        String selectUsername = "SELECT * FROM Patients WHERE Username = ?";
        try {
            PreparedStatement statement = con.prepareStatement(selectUsername);
            statement.setString(1, username);
            ResultSet resultSet = statement.executeQuery();
            // returns false if the cursor is not before the first record or if there are no rows in the ResultSet.
            return resultSet.isBeforeFirst();
        } catch (SQLException e) {
            System.out.println("Error occurred when checking username");
            e.printStackTrace();
        } finally {
            cm.closeConnection();
        }
        return true;
    }

    private static boolean usernameExistsCaregiver(String username) {
        ConnectionManager cm = new ConnectionManager();
        Connection con = cm.createConnection();

        String selectUsername = "SELECT * FROM Caregivers WHERE Username = ?";
        try {
            PreparedStatement statement = con.prepareStatement(selectUsername);
            statement.setString(1, username);
            ResultSet resultSet = statement.executeQuery();
            // returns false if the cursor is not before the first record or if there are no rows in the ResultSet.
            return resultSet.isBeforeFirst();
        } catch (SQLException e) {
            System.out.println("Error occurred when checking username");
            e.printStackTrace();
        } finally {
            cm.closeConnection();
        }
        return true;
    }

    private static void loginPatient(String[] tokens) {
        // login_patient <username> <password>
        // check 1: if someone's already logged-in, they need to log out first
        if (currentPatient != null || currentCaregiver != null) {
            System.out.println("User already logged in.");
            return;
        }
        // check 2: the length for tokens need to be exactly 3 to include all information (with the operation name)
        if (tokens.length != 3) {
            System.out.println("Login failed.");
            return;
        }
        String username = tokens[1];
        String password = tokens[2];

        Patient patient = null;
        try {
            patient = new Patient.PatientGetter(username, password).get();
        } catch (SQLException e) {
            System.out.println("Login failed.");
            e.printStackTrace();
        }
        // check if the login was successful
        if (patient == null) {
            System.out.println("Login failed.");
        } else {
            System.out.println("Logged in as: " + username);
            currentPatient = patient;
        }
    }

    private static void loginCaregiver(String[] tokens) {
        // login_caregiver <username> <password>
        // check 1: if someone's already logged-in, they need to log out first
        if (currentCaregiver != null || currentPatient != null) {
            System.out.println("User already logged in.");
            return;
        }
        // check 2: the length for tokens need to be exactly 3 to include all information (with the operation name)
        if (tokens.length != 3) {
            System.out.println("Login failed.");
            return;
        }
        String username = tokens[1];
        String password = tokens[2];

        Caregiver caregiver = null;
        try {
            caregiver = new Caregiver.CaregiverGetter(username, password).get();
        } catch (SQLException e) {
            System.out.println("Login failed.");
            e.printStackTrace();
        }
        // check if the login was successful
        if (caregiver == null) {
            System.out.println("Login failed.");
        } else {
            System.out.println("Logged in as: " + username);
            currentCaregiver = caregiver;
        }
    }

    private static boolean isLoggedIn() {
        return (currentPatient != null || currentCaregiver != null);
    }

    private static TreeSet<String> getAvailableCaregivers(String date) {
        ConnectionManager cm = new ConnectionManager();
        Connection con = cm.createConnection();

        String selectAvailableCaregivers = "SELECT Username FROM Availabilities WHERE Time = ?";
        TreeSet<String> caregiverSchedule = new TreeSet<>();
        try {
            Date d = Date.valueOf(date);
            PreparedStatement statement = con.prepareStatement(selectAvailableCaregivers);
            statement.setDate(1, d);
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                String username = resultSet.getString("Username");
                caregiverSchedule.add(username);
            }
        } catch (SQLException e) {
            System.out.println("Error occurred when checking Caregivers");
            e.printStackTrace();
        } finally {
            cm.closeConnection();
        }
        return caregiverSchedule;
    }

    private static Map<String, Integer> getAvailableVaccine() {
        ConnectionManager cm = new ConnectionManager();
        Connection con = cm.createConnection();

        String selectVaccines = "SELECT Name, Doses FROM Vaccines";
        Map<String, Integer> availableVaccine = new TreeMap<>();
        try {
            PreparedStatement statementV = con.prepareStatement(selectVaccines);
            ResultSet resultSet = statementV.executeQuery();
            while (resultSet.next()) {
                String vaccineName = resultSet.getString("Name");
                int vaccineDoses = resultSet.getInt("Doses");
                availableVaccine.put(vaccineName, vaccineDoses);
            }
        } catch (SQLException e) {
            System.out.println("Error occurred when checking vaccine");
            e.printStackTrace();
        } finally {
            cm.closeConnection();
        }
        return availableVaccine;
    }
    private static void searchCaregiverSchedule(String[] tokens) {
//  login_patient p1 123
//  search_caregiver_schedule 0101
        if(!isLoggedIn()) {
            System.out.println("Please login first!");
            return;
        } else if (tokens.length != 2) {
            System.out.println("Please try again!");
            return;
        }
        String date = tokens[1];
        TreeSet<String> availableCaregiver = getAvailableCaregivers(date);
        Map<String, Integer> availableVaccine = getAvailableVaccine();
        for(String caregiverName : availableCaregiver) {
            for(String vaccineName : availableVaccine.keySet()) {
                int vaccineDoses = availableVaccine.get(vaccineName);
                System.out.println(caregiverName + " " + vaccineName + " " + vaccineDoses);
            }
        }
    }

    private static void reserve(String[] tokens) {
        if(!isLoggedIn()) {
            System.out.println("Please login first!");
        } else if (currentCaregiver != null) {
            System.out.println("Please login as a patient!");
        } else if (currentPatient != null) {
            String date = tokens[1];
            String vaccineName = tokens[2];
            TreeSet<String> availableCaregiver = getAvailableCaregivers(date);
            Map<String, Integer> availableVaccine = getAvailableVaccine();
            boolean vaccineIsAvailable = false;
            if(availableVaccine.containsKey(vaccineName)) {
                vaccineIsAvailable = true;
            }
            if(availableCaregiver.size() == 0) {
                System.out.println("“No Caregiver is available!");
            } else if(!vaccineIsAvailable) {
                System.out.println("Not enough available doses!");
            } else {
                Date d = Date.valueOf(date);
                String assignedCaregiver = availableCaregiver.first();
                createAppointment(d, assignedCaregiver, vaccineName); //create appointment, upload isCheckedBy, decrease doses, and remove availability
                //update not available caregiver >>delete from availability
            }
        } else {
            System.out.println("Please try again!");
        }
    }

    private static void uploadAvailability(String[] tokens) {
        // upload_availability <date>
        // check 1: check if the current logged-in user is a caregiver
        if (currentCaregiver == null) {
            System.out.println("Please login as a caregiver first!");
            return;
        }
        // check 2: the length for tokens need to be exactly 2 to include all information (with the operation name)
        if (tokens.length != 2) {
            System.out.println("Please try again!");
            return;
        }
        String date = tokens[1];
        try {
            Date d = Date.valueOf(date);
            currentCaregiver.uploadAvailability(d);
            System.out.println("Availability uploaded!");
        } catch (IllegalArgumentException e) {
            System.out.println("Please enter a valid date!");
        } catch (SQLException e) {
            System.out.println("Error occurred when uploading availability");
            e.printStackTrace();
        }
    }


    private static void removeAvailability(Date d, String assignedCaregiver) throws SQLException {
        ConnectionManager cm = new ConnectionManager();
        Connection con = cm.createConnection();

        String removeAvailabilityForAssigned = "DELETE FROM Availabilities WHERE Time = ? AND Username = ?";
        try {
            PreparedStatement statement = con.prepareStatement(removeAvailabilityForAssigned);
            statement.setDate(1, d);
            statement.setString(2, assignedCaregiver);
            statement.executeUpdate();
        } catch (SQLException e) {
            System.out.println("error in removing availability "+ e.getMessage());
            throw new SQLException();
        } finally {
            cm.closeConnection();
        }
    }

    private static void cancel(String[] tokens) {
        // TODO: Extra credit
    }

    private static void addDoses(String[] tokens) {
        // add_doses <vaccine> <number>
        // check 1: check if the current logged-in user is a caregiver
        if (currentCaregiver == null) {
            System.out.println("Please login as a caregiver first!");
            return;
        }
        // check 2: the length for tokens need to be exactly 3 to include all information (with the operation name)
        if (tokens.length != 3) {
            System.out.println("Please try again!");
            return;
        }
        String vaccineName = tokens[1];
        int doses = Integer.parseInt(tokens[2]);
        Vaccine vaccine = null;
        try {
            vaccine = new Vaccine.VaccineGetter(vaccineName).get();
        } catch (SQLException e) {
            System.out.println("Error occurred when adding doses");
            e.printStackTrace();
        }
        // check 3: if getter returns null, it means that we need to create the vaccine and insert it into the Vaccines
        //          table
        if (vaccine == null) {
            try {
                vaccine = new Vaccine.VaccineBuilder(vaccineName, doses).build();
                vaccine.saveToDB();
            } catch (SQLException e) {
                ////
                e.printStackTrace();
            }
        } else {
            // if the vaccine is not null, meaning that the vaccine already exists in our table
            try {
                vaccine.increaseAvailableDoses(doses);
            } catch (SQLException e) {
                System.out.println("Error occurred when adding doses");
                e.printStackTrace();
            }
        }
        System.out.println("Doses updated!");
    }

    private static void showAppointments(String[] tokens) {
        if (!isLoggedIn()) {
            System.out.println("Please login first!");
            return;
        }

        String appointmentData;
        if (currentPatient != null) {
            appointmentData = "SELECT A.AppointmentID, V.Name, A.Time, C.Username " +
                    "FROM Appointments A " +
                    "JOIN Vaccines V ON A.Name = V.Name " +
                    "JOIN Caregivers C ON A.UsernameC = C.Username " +
                    "WHERE A.UsernameP = ? " +
                    "ORDER BY A.AppointmentID";
        } else if (currentCaregiver != null) {
            appointmentData = "SELECT A.AppointmentID, V.Name, A.Time, P.Username " +
                    "FROM Appointments A " +
                    "JOIN Vaccines V ON A.Name = V.Name " +
                    "JOIN Patients P ON A.UsernameP = P.Username " +
                    "WHERE A.UsernameC = ? " +
                    "ORDER BY A.AppointmentID";
        } else {
            System.out.println("Please try again!");
            return;
        }

        ConnectionManager cm = new ConnectionManager();
        try (Connection con = cm.createConnection();
             PreparedStatement stmt = con.prepareStatement(appointmentData)) {

            String currentUser = (currentPatient != null) ? currentPatient.getUsername() : currentCaregiver.getUsername();
            stmt.setString(1, currentUser);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    String appointmentID = rs.getString("AppointmentID");
                    String vaccineName = rs.getString("Name");
                    Date date = rs.getDate("Time");
                    String otherUser = rs.getString(4);

                    String output = appointmentID + " " + vaccineName + " " + date + " " + otherUser;
                    System.out.println(output);
                }
            }
        } catch (SQLException e) {
            System.out.println("An error occurred: " + e.getMessage());
            e.printStackTrace();
        }
    }





    private static void logout(String[] tokens) {
        if (currentPatient == null && currentCaregiver == null) {
            System.out.println("Please login first.");
        } else if (currentPatient != null || currentCaregiver != null){
            currentCaregiver = null;
            currentPatient = null;
            System.out.println("Successfully logged out!");
        } else {
            System.out.println("Please try again!");
        }
    }
}
