#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <sstream>
#include <algorithm>
#include <stdexcept>

using namespace std;

// Custom exception for invalid inputs
class InvalidInputException : public runtime_error {
public:
    InvalidInputException(const string& msg) : runtime_error(msg) {}
};

// Base User class
class User {
protected:
    string username;
    string password;
    string type; // "seeker" or "employer"
    string email;
    string phone;
public:
    User(string u, string p, string t, string e = "", string ph = "") : username(u), password(p), type(t), email(e), phone(ph) {}
    string getUsername() { return username; }
    string getPassword() { return password; }
    string getType() { return type; }
    string getEmail() { return email; }
    string getPhone() { return phone; }
    void setEmail(string e) { email = e; }
    void setPhone(string ph) { phone = ph; }
    virtual void displayMenu() = 0; // Pure virtual for polymorphism
    void viewProfile() {
        cout << "Username: " << username << "\nEmail: " << email << "\nPhone: " << phone << endl;
    }
    void editProfile() {
        cout << "New Email: "; cin >> email;
        cout << "New Phone: "; cin >> phone;
        saveProfile();
        cout << "Profile updated!\n";
    }
    void saveProfile() {
        ofstream file("profiles.txt", ios::app);
        file << username << "," << email << "," << phone << endl;
    }
    void loadProfile() {
        ifstream file("profiles.txt");
        string line;
        while (getline(file, line)) {
            stringstream ss(line);
            string u, e, ph;
            getline(ss, u, ',');
            getline(ss, e, ',');
            getline(ss, ph, ',');
            if (u == username) {
                email = e;
                phone = ph;
                break;
            }
        }
    }
};

// Job Seeker class
class JobSeeker : public User {
private:
    string resume;
public:
    JobSeeker(string u, string p, string e = "", string ph = "") : User(u, p, "seeker", e, ph) { loadResume(); }
    void displayMenu() override {
        cout << "1. Search Jobs\n2. Apply for Job\n3. View Applications\n4. View/Edit Profile\n5. View/Update Resume\n6. Logout\n";
    }
    void searchJobs(vector<string>& jobs, string keyword = "") {
        cout << "Available Jobs:\n";
        for (auto& job : jobs) {
            if (keyword.empty() || job.find(keyword) != string::npos) {
                cout << job << endl;
            }
        }
    }
    void applyForJob(int jobId, string username) {
        ofstream file("applications.txt", ios::app);
        file << jobId << "," << username << ",Pending" << endl;
        cout << "Applied successfully!\n";
    }
    void viewApplications(vector<string>& applications) {
        cout << "Your Applications:\n";
        for (auto& app : applications) {
            stringstream ss(app);
            string jid, uname, status;
            getline(ss, jid, ',');
            getline(ss, uname, ',');
            getline(ss, status, ',');
            if (uname == username) cout << "Job ID: " << jid << " - Status: " << status << endl;
        }
    }
    void updateResume() {
        cout << "Enter Resume: ";
        cin.ignore();
        getline(cin, resume);
        ofstream file("resumes.txt", ios::app);
        file << username << "," << resume << endl;
        cout << "Resume updated!\n";
    }
    void loadResume() {
        ifstream file("resumes.txt");
        string line;
        while (getline(file, line)) {
            stringstream ss(line);
            string u, r;
            getline(ss, u, ',');
            getline(ss, r);
            if (u == username) {
                resume = r;
                break;
            }
        }
    }
    string getResume() { return resume; }
};

// Employer class
class Employer : public User {
public:
    Employer(string u, string p, string e = "", string ph = "") : User(u, p, "employer", e, ph) {}
    void displayMenu() override {
        cout << "1. Post Job\n2. View/Edit Posted Jobs\n3. View Applicants\n4. Update Application Status\n5. View/Edit Profile\n6. Logout\n";
    }
    void postJob(string title, string company, string desc, string username, vector<string>& jobs) {
        static int jobId = 1;
        ofstream file("jobs.txt", ios::app);
        file << jobId << "," << title << "," << company << "," << desc << "," << username << endl;
        jobs.push_back(to_string(jobId) + "," + title + "," + company + "," + desc + "," + username);
        cout << "Job posted with ID: " << jobId << endl;
        jobId++;
    }
    void viewJobs(vector<string>& jobs) {
        cout << "Your Jobs:\n";
        for (auto& job : jobs) {
            stringstream ss(job);
            string id, title, comp, desc, by;
            getline(ss, id, ',');
            getline(ss, title, ',');
            getline(ss, comp, ',');
            getline(ss, desc, ',');
            getline(ss, by, ',');
            if (by == username) cout << job << endl;
        }
    }
    void editJob(vector<string>& jobs) {
        int id;
        cout << "Enter Job ID to edit: "; cin >> id;
        string newTitle, newComp, newDesc;
        cout << "New Title: "; cin.ignore(); getline(cin, newTitle);
        cout << "New Company: "; getline(cin, newComp);
        cout << "New Description: "; getline(cin, newDesc);
        for (auto& job : jobs) {
            stringstream ss(job);
            string jid;
            getline(ss, jid, ',');
            if (stoi(jid) == id) {
                job = to_string(id) + "," + newTitle + "," + newComp + "," + newDesc + "," + username;
                ofstream file("jobs.txt");
                for (auto& j : jobs) file << j << endl;
                cout << "Job updated!\n";
                return;
            }
        }
        cout << "Job not found!\n";
    }
    void viewApplicants(vector<string>& applications, vector<string>& jobs) {
        cout << "Applicants for your jobs:\n";
        for (auto& app : applications) {
            stringstream ss(app);
            string jid, uname, status;
            getline(ss, jid, ',');
            getline(ss, uname, ',');
            getline(ss, status, ',');
            for (auto& job : jobs) {
                if (job.find(jid + ",") == 0 && job.find("," + username) != string::npos) {
                    cout << "Job ID: " << jid << " - Applicant: " << uname << " - Status: " << status << endl;
                }
            }
        }
    }
    void updateApplicationStatus(vector<string>& applications) {
        int jid;
        string uname, newStatus;
        cout << "Job ID: "; cin >> jid;
        cout << "Applicant Username: "; cin >> uname;
        cout << "New Status (Accepted/Rejected/Pending): "; cin >> newStatus;
        for (auto& app : applications) {
            stringstream ss(app);
            string id, u, s;
            getline(ss, id, ',');
            getline(ss, u, ',');
            getline(ss, s, ',');
            if (stoi(id) == jid && u == uname) {
                app = id + "," + u + "," + newStatus;
                ofstream file("applications.txt");
                for (auto& a : applications) file << a << endl;
                cout << "Status updated!\n";
                return;
            }
        }
        cout << "Application not found!\n";
    }
};

// Job Portal class
class JobPortal {
private:
    vector<User*> users;
    vector<string> jobs;
    vector<string> applications;
    vector<string> notifications;
public:
    JobPortal() {
        loadUsers();
        loadJobs();
        loadApplications();
        loadProfiles();
    }
    ~JobPortal() {
        for (auto u : users) delete u;
    }
    void loadUsers() {
        ifstream file("users.txt");
        string line;
        while (getline(file, line)) {
            stringstream ss(line);
            string u, p, t, e, ph;
            getline(ss, u, ',');
            getline(ss, p, ',');
            getline(ss, t, ',');
            getline(ss, e, ',');
            getline(ss, ph, ',');
            if (t == "seeker") users.push_back(new JobSeeker(u, p, e, ph));
            else users.push_back(new Employer(u, p, e, ph));
        }
    }
    void loadJobs() {
        ifstream file("jobs.txt");
        string line;
        while (getline(file, line)) jobs.push_back(line);
    }
    void loadApplications() {
        ifstream file("applications.txt");
        string line;
        while (getline(file, line)) applications.push_back(line);
    }
    void loadProfiles() {
        for (auto u : users) u->loadProfile();
    }
    void registerUser() {
        try {
            string u, p, t, e, ph;
            cout << "Username: "; cin >> u;
            if (u.empty()) throw InvalidInputException("Username cannot be empty!");
            cout << "Password: "; cin >> p;
            if (p.empty()) throw InvalidInputException("Password cannot be empty!");
            cout << "Type (seeker/employer): "; cin >> t;
            if (t != "seeker" && t != "employer") throw InvalidInputException("Invalid type!");
            cout << "Email: "; cin >> e;
            cout << "Phone: "; cin >> ph;
            ofstream file("users.txt", ios::app);
            file << u << "," << p << "," << t << "," << e << "," << ph << endl;
            if (t == "seeker") users.push_back(new JobSeeker(u, p, e, ph));
            else users.push_back(new Employer(u, p, e, ph));
            cout << "Registered!\n";
        } catch (const InvalidInputException& e) {
            cout << "Error: " << e.what() << endl;
        }
    }
    User* login() {
        string u, p;
        cout << "Username: "; cin >> u;
        cout << "Password: "; cin >> p;
        for (auto user : users) {
            if (user->getUsername() == u && user->getPassword() == p) {
                user->loadProfile();
                return user;
            }
        }
        return nullptr;
    }
    void addNotification(string msg) {
        notifications.push_back(msg);
    }
    void viewNotifications() {
        cout << "Notifications:\n";
        for (auto& n : notifications) cout << n << endl;
        notifications.clear();
    }
    void run() {
        while (true) {
            cout << "1. Register\n2. Login\n3. View Notifications\n4. Exit\n";
            int choice;
            cin >> choice;
            if (choice == 1) registerUser();
            else if (choice == 2) {
                User* user = login();
                if (!user) { cout << "Invalid credentials!\n"; continue; }
                while (true) {
                    user->displayMenu();
                    int opt;
                    cin >> opt;
                    if (user->getType() == "seeker") {
                        JobSeeker* seeker = dynamic_cast<JobSeeker*>(user);
                        if (opt == 1) {
                            string kw;
                            cout << "Search keyword (leave empty for all): ";
                            cin.ignore();
                            getline(cin, kw);
                            seeker->searchJobs(jobs, kw);
                        } else if (opt == 2) {
                            int id;
                            cout << "Job ID: "; cin >> id;
                            seeker->applyForJob(id, user->getUsername());
                            addNotification("New application for Job ID " + to_string(id));
                        } else if (opt == 3) seeker->viewApplications(applications);
                        else if (opt == 4) user->viewProfile();
                        else if (opt == 5) seeker->updateResume();
                        else break;
                    } else {
                        Employer* emp = dynamic_cast<Employer*>(user);
                        if (opt == 1) {
                            string t, c, d;
                            cout << "Title: "; cin.ignore(); getline(cin, t);
                            cout << "Company: "; getline(cin, c);
                            cout << "Description: "; getline(cin, d);
                            emp->postJob(t, c, d, user->getUsername(), jobs);
                        } else if (opt == 2) {
                            emp->viewJobs(jobs);
                            cout << "Edit job? (y/n): ";
                            char ch; cin >> ch;
                            if (ch == 'y') emp->editJob(jobs);
                        } else if (opt == 3) emp->viewApplicants(applications, jobs);
                        else if (opt == 4) emp->updateApplicationStatus(applications);
                        else if (opt == 5) user->viewProfile();
                        else break;
                    }
                }
            } else if (choice == 3) viewNotifications();
            else break;
        }
    }
};

int main() {
    JobPortal portal;
    portal.run();
    return 0;
}
