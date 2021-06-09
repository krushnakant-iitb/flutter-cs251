# Notify Me- A Flutter Application

This is a project that is a flutter application, 
which includes most of the dashboard features, except signup. 
Specialized features like notifications are android-specific 
while others are also available on ios.

app-release.apk is the apk file for this app.

# Key Features

## Login Page

This page facilitates the login of a user. It has a 
specially designed pleasant look,
giving a nice User Experience. Once Logged In, User cannot use 
Android's back button; so the password is not revealed.

## Notifications

This app can receive notifications sent by Professors/TAs if the 
user logged in is registered for the course.
If it is a low priority message, it only appears on the 
notifications list.
If high priority, the user receives a push notification, which
overrides silent/DND features and rings a tone unless 
the device is on mute.

## Acknowledgement

If there are some messages not acknowledged by the logged in user,
this page is shown. It lists all the unread messages by the user.
This page can only be escaped once the "Acknowledge" button 
is tapped by the user to acknowledge.
After this, the user's name is added in the list of users who have 
read the message.

## Home Page

After Login, user is redirected to this page unless some Messages 
require acknowledgement.
It contains the List of courses the user is registered for.
If the user is a professor he can add courses.


## Members Page

A user when clicks on the "members" button on a course card is redirected to this page.
Everyone can see the list of users in a course that they are part of including the professor himself.
The professor can also remove students of the course if suspicious activities are detected.

## Course Home Page

Messages can be sent and received.
Prof can send messages to both TA and student .
Message to TA cannot be seen by the students.
TA can send messages to students not professors.
Professor can add both TA and students but TA can only add students
Students do not have any control(Especially they can’t send messages/add users to make sure to have only important stuff on the page).
So each message has a header which contains the sender's username
which on click gives the list of users who read the  message
The body contains the message.
Message has two forms.Low priority and High Priority Messages.

## ReadBy Page

If a user clicks on a message, it redirects to this page.
It contains the list of users who have acknowledged that 
particular message.
