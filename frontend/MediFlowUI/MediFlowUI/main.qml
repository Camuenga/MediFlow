import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: window

    visible: true
    width: 900
    height: 700
    minimumWidth: 750
    minimumHeight: 600

    title: "MediFlow AI"

    property bool loading: false

    color: "#f4f7fb"

    // ============================================================
    // CLEANING DATA MEMORY
    // ============================================================
    function clearPatientData()
    {
        nameValue.text = "-"
        ageValue.text = "-"
        reasonValue.text = "-"
        durationValue.text = "-"
        phoneValue.text = "-"
        departmentValue.text = "-"
        statusValue.text = "Processing..."
    }

    // ============================================================
    // API CONNECTION
    // ============================================================

    Connections {
        target: mediFlowApi

        function onResultReceived(result) {
            loading = false

                try{
                    var data = JSON.parse(result)

                    if(data.error){
                        statusValue.text = "Error: " + data.error
                        return
                    }

                    nameValue.text = data.name || "-"
                    ageValue.text = data.age || "-"
                    reasonValue.text = data.reason || "-"
                    durationValue.text = data.duration || "-"
                    phoneValue.text = data.phone || "-"
                    if (data.routing) {
                       departmentValue.text = data.routing.department
                   } else {
                       departmentValue.text = "-"
                   }

                   // ==========================================
                   // VALIDATION
                   // ==========================================

                   if (data.validation &&
                       data.validation.valid === false) {

                       statusValue.text =
                           "INCOMPLETE — Please provide the missing information"

                       return
                   }

                   // ==========================================
                   // VERIFICATION
                   // ==========================================

                   if (data.verification &&
                       data.verification.approved === true) {

                       statusValue.text = "APPROVED ✓"

                   } else {

                       statusValue.text = "REJECTED ✗"
                   }
                }catch(e){
                statusValue.text ="ERROR — Invalid server response"

                       console.log("JSON error:", e)
                       console.log("Server response:", result)
            }
        }

        function onErrorOccurred(error) {
            loading = false
            statusValue.text = "Unable to process the request. Please try again."
            //statusValue.text = "ERROR: " + error INFORMATIO TO debugge

        }
    }

    // ============================================================
    // MAIN LAYOUT
    // ============================================================

    ColumnLayout {
        anchors.fill: parent
        width: parent.width
        spacing: 0
        // ========================================================
        // HEADER
        // ========================================================

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 90

            color: "#ffffff"

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                height: 1
                color: "#e5e9f0"
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 35
                anchors.rightMargin: 35

                spacing: 15

                Rectangle {
                    Layout.preferredWidth: 48
                    Layout.preferredHeight: 48

                    radius: 12
                    color: "#2563eb"

                    Label {
                        anchors.centerIn: parent

                        text: "M"
                        color: "white"

                        font.pixelSize: 26
                        font.bold: true
                    }
                }

                ColumnLayout {
                    spacing: 2

                    Label {
                        text: "MediFlow AI"

                        color: "#172033"

                        font.pixelSize: 25
                        font.bold: true
                    }

                    Label {
                        text: "Healthcare Administrative Intake"

                        color: "#7a8497"

                        font.pixelSize: 13
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                Rectangle {
                    Layout.preferredWidth: 105
                    Layout.preferredHeight: 34

                    radius: 17
                    color: "#ecfdf5"

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 7

                        Rectangle {
                            Layout.preferredWidth: 8
                            Layout.preferredHeight: 8

                            radius: 4
                            color: "#10b981"
                        }

                        Label {
                            text: "ONLINE"

                            color: "#047857"

                            font.pixelSize: 11
                            font.bold: true
                        }
                    }
                }
            }
        }

        // ========================================================
        // CONTENT
        // ========================================================

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            clip: true
            contentWidth: availableWidth
            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            ColumnLayout {

                width: parent.width
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 35
                anchors.rightMargin: 35

                spacing: 22

                // =================================================
                // WELCOME
                // =================================================

                ColumnLayout {
                    Layout.fillWidth: true

                    Layout.topMargin: 28

                    spacing: 5

                    Label {
                        text: "Patient Intake"

                        color: "#172033"

                        font.pixelSize: 28
                        font.bold: true
                    }

                    Label {
                        text: "Enter the patient's information to begin the administrative intake."

                        color: "#6b7280"

                        font.pixelSize: 14
                    }
                }

                // =================================================
                // INPUT CARD
                // =================================================

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 300

                    radius: 16

                    color: "#ffffff"

                    border.width: 1
                    border.color: "#e4e8ef"

                    ColumnLayout {
                        anchors.fill: parent

                        anchors.margins: 24

                        spacing: 15

                        Label {
                            text: "Patient Message"

                            color: "#172033"

                            font.pixelSize: 17
                            font.bold: true
                        }

                        Label {
                            text: "Describe the reason for the patient's visit."

                            color: "#7a8497"

                            font.pixelSize: 13
                        }

                        TextArea {
                            id: messageInput

                            Layout.fillWidth: true
                            Layout.preferredHeight: 130

                            placeholderText:
                                "Example: My name is João Manuel. I am 35 years old and I have had a headache for three days. My phone is 923000000."

                            placeholderTextColor: "#9aa3b2"

                            wrapMode: TextArea.Wrap

                            font.pixelSize: 14

                            color: "#172033"

                            leftPadding: 15
                            rightPadding: 15
                            topPadding: 13
                            bottomPadding: 13
                            selectByMouse: true
                            background: Rectangle {
                                radius: 10
                                color: "#f8fafc"
                              border.width: 1
                                border.color:
                                    messageInput.activeFocus
                                    ? "#2563eb"
                                    : "#dfe4ec"
                            }
                            ScrollBar.vertical: ScrollBar{
                                policy: ScrollBar.AsNeeded
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true

                            spacing: 12

                            Item {
                                Layout.fillWidth: true
                            }

                            Label {
                                visible: loading

                                text: "Processing patient information..."

                                color: "#6b7280"

                                font.pixelSize: 12
                            }

                            Button {
                                id: sendButton

                                Layout.preferredWidth: 135
                                Layout.preferredHeight: 44

                                enabled:
                                    !loading &&
                                    messageInput.text.trim().length > 0

                                text:
                                    loading
                                    ? "SENDING..."
                                    : "SEND"

                                font.pixelSize: 13
                                font.bold: true

                                contentItem: Label {
                                    text: sendButton.text

                                    color: sendButton.enabled
                                           ? "white"
                                           : "#9ca3af"

                                    horizontalAlignment:
                                        Text.AlignHCenter

                                    verticalAlignment:
                                        Text.AlignVCenter

                                    font.pixelSize: 13
                                    font.bold: true
                                }

                                background: Rectangle {
                                    radius: 10

                                    color:
                                        sendButton.enabled
                                        ? "#2563eb"
                                        : "#e5e7eb"

                                    Behavior on color {
                                        ColorAnimation {
                                            duration: 150
                                        }
                                    }
                                }

                                onClicked: {
                                    clearPatientData()
                                    loading = true

                                    mediFlowApi.sendMessage(
                                        messageInput.text
                                    )
                                }
                            }
                        }
                    }
                }

                // =================================================
                // PATIENT INFORMATION CARD
                // =================================================

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 315

                    radius: 16

                    color: "#ffffff"

                    border.width: 1
                    border.color: "#e4e8ef"

                    ColumnLayout {
                        anchors.fill: parent

                        anchors.margins: 24

                        spacing: 18

                        // -----------------------------------------
                        // CARD HEADER
                        // -----------------------------------------

                        RowLayout {
                            Layout.fillWidth: true

                            spacing: 12

                            Rectangle {
                                Layout.preferredWidth: 42
                                Layout.preferredHeight: 42

                                radius: 10

                                color: "#eff6ff"

                                Label {
                                    anchors.centerIn: parent

                                    text: "P"

                                    color: "#2563eb"

                                    font.pixelSize: 20
                                    font.bold: true
                                }
                            }

                            ColumnLayout {
                                spacing: 2

                                Label {
                                    text: "Patient Information"

                                    color: "#172033"

                                    font.pixelSize: 18
                                    font.bold: true
                                }

                                Label {
                                    text: "Verified administrative data"

                                    color: "#7a8497"

                                    font.pixelSize: 12
                                }
                            }

                            Item {
                                Layout.fillWidth: true
                            }
                        }

                        // -----------------------------------------
                        // INFORMATION GRID
                        // -----------------------------------------

                        GridLayout {
                            Layout.fillWidth: true

                            columns: 2

                            columnSpacing: 40
                            rowSpacing: 12

                            // NAME

                            Label {
                                text: "NAME"

                                color: "#8993a5"

                                font.pixelSize: 10
                                font.bold: true
                            }

                            Label {
                                id: nameValue

                                Layout.fillWidth: true

                                text: "-"

                                color: "#172033"

                                font.pixelSize: 14
                            }

                            // AGE

                            Label {
                                text: "AGE"

                                color: "#8993a5"

                                font.pixelSize: 10
                                font.bold: true
                            }

                            Label {
                                id: ageValue

                                Layout.fillWidth: true

                                text: "-"

                                color: "#172033"

                                font.pixelSize: 14
                            }

                            // REASON

                            Label {
                                text: "REASON"

                                color: "#8993a5"

                                font.pixelSize: 10
                                font.bold: true
                            }

                            Label {
                                id: reasonValue

                                Layout.fillWidth: true

                                text: "-"

                                color: "#172033"

                                font.pixelSize: 14

                                elide: Text.ElideRight
                            }

                            // DURATION

                            Label {
                                text: "DURATION"

                                color: "#8993a5"

                                font.pixelSize: 10
                                font.bold: true
                            }

                            Label {
                                id: durationValue

                                Layout.fillWidth: true

                                text: "-"

                                color: "#172033"

                                font.pixelSize: 14
                            }

                            // PHONE

                            Label {
                                text: "PHONE"

                                color: "#8993a5"

                                font.pixelSize: 10
                                font.bold: true
                            }

                            Label {
                                id: phoneValue

                                Layout.fillWidth: true

                                text: "-"

                                color: "#172033"

                                font.pixelSize: 14
                            }

                            // DEPARTMENT

                            Label {
                                text: "DEPARTMENT"

                                color: "#8993a5"

                                font.pixelSize: 10
                                font.bold: true
                            }

                            Label {
                                id: departmentValue

                                Layout.fillWidth: true

                                text: "-"

                                color: "#172033"

                                font.pixelSize: 14
                            }
                        }

                        // -----------------------------------------
                        // STATUS
                        // -----------------------------------------

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 50

                            radius: 10

                            color:
                                statusValue.text === "APPROVED ✓"
                                ? "#ecfdf5"
                                : statusValue.text === "REJECTED ✗"
                                ? "#fef2f2"
                                : statusValue.text.startsWith("ERROR")
                                ? "#fff7ed"
                                : "#f8fafc"

                            border.width: 1

                            border.color:
                                statusValue.text === "APPROVED ✓"
                                ? "#a7f3d0"
                                : statusValue.text === "REJECTED ✗"
                                ? "#fecaca"
                                : statusValue.text.startsWith("ERROR")
                                ? "#fed7aa"
                                : "#e5e7eb"

                            Label {
                                id: statusValue

                                anchors.centerIn: parent

                                text: "-"

                                color:
                                    text === "APPROVED ✓"
                                    ? "#047857"
                                    : text === "REJECTED ✗"
                                    ? "#b91c1c"
                                    : text.startsWith("ERROR")
                                    ? "#c2410c"
                                    : "#6b7280"

                                font.pixelSize: 14
                                font.bold: true
                            }
                        }
                    }
                }

                // =================================================
                // FOOTER
                // =================================================

                Label {
                    Layout.fillWidth: true

                    Layout.bottomMargin: 25

                    text: "MediFlow AI • Administrative healthcare assistance"

                    color: "#9aa3b2"

                    font.pixelSize: 11

                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }
}
