import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: window

    visible: true
    width: 900
    height: 850
    minimumWidth: 750
    minimumHeight: 650

    title: "MediFlow AI"
    color: "#f4f7fb"

    property bool loading: false

    // ============================================================
    // PATIENT INFORMATION DATA
    // ============================================================

    property string patientInfoName: "-"
    property string patientInfoAge: "-"
    property string patientInfoReason: "-"
    property string patientInfoDuration: "-"
    property string patientInfoPhone: "-"
    property string patientInfoDepartment: "-"
    property string maskara : "_"
    property int amountNumber : 0
    property string textoSelecionado

    function aplicarMascaraPorPais(textoSelecionado) {
            // 1. Extracts the country code from inside the parentheses (e.g., "Angola (+244)" -> "+244")
            let regExp = /\(([^)]+)\)/;
            let matches = regExp.exec(textoSelecionado);
            let indicativo = matches ? matches[1] : "";

            // 2. Main Logic: Sets the local digit length and exact mask structure based on your list

            // --- 11 DIGITS ---
            if (indicativo === "+55") { // Brazil
                amountNumber = 11;
                maskara = "(##) #####-####";
            }
            else if (indicativo === "+86") { // China
                amountNumber = 11;
                maskara = "### #### ####";
            }
            else if (indicativo === "+54") { // Argentina
                amountNumber = 11;
                maskara = "## ## ####-####";
            }

            // --- 10 DIGITS ---
            else if (indicativo === "+1") { // Canada, USA, Bahamas, Barbados, Jamaica, etc.
                amountNumber = 10;
                maskara = "(###) ###-####";
            }
            else if (indicativo === "+91") { // India
                amountNumber = 10;
                maskara = "##### #####";
            }
            else if (indicativo === "+81") { // Japan
                amountNumber = 10;
                maskara = "## #### ####";
            }
            else if (indicativo === "+7") { // Kazakhstan, Russia
                amountNumber = 10;
                maskara = "### ###-##-##";
            }
            else if (indicativo === "+62") { // Indonesia
                amountNumber = 10;
                maskara = "#### #### ##";
            }
            else if (indicativo === "+92") { // Pakistan
                amountNumber = 10;
                maskara = "### #######";
            }

            // --- 9 DIGITS (Standard for most of your list, including PALOP & Western Europe) ---
            else if (indicativo === "+244" || indicativo === "+258" || indicativo === "+238" || indicativo === "+245" ||
                     indicativo === "+351" || indicativo === "+34" || indicativo === "+33" || indicativo === "+39" || indicativo === "+49" ||
                     indicativo === "+32" || indicativo === "+43" || indicativo === "+45" || indicativo === "+47" ||
                     indicativo === "+56" || indicativo === "+57" || indicativo === "+52" || indicativo === "+51" ||
                     indicativo === "+213" || indicativo === "+234" || indicativo === "+20" || indicativo === "+212" || indicativo === "+254") {

                amountNumber = 9;

                // Grouping common layouts for 9-digit countries
                if (indicativo === "+244" || indicativo === "+351" || indicativo === "+34" || indicativo === "+258" || indicativo === "+238") {
                    maskara = "### ### ###"; // Angola, Portugal, Spain, Mozambique, Cape Verde
                } else if (indicativo === "+33" || indicativo === "+49" || indicativo === "+32") {
                    maskara = "# ## ## ## ##"; // France, Germany, Belgium
                } else {
                    maskara = "#########"; // Clean fallback for other 9-digit countries
                }
            }

            // --- 8 DIGITS ---
            else if (indicativo === "+376" || indicativo === "+506" || indicativo === "+502" || indicativo === "+503" || indicativo === "+504" || indicativo === "+505" ||
                     indicativo === "+850" || indicativo === "+973" || indicativo === "+965" || indicativo === "+968") {
                amountNumber = 8;
                maskara = "#### ####";
            }

            // --- 7 DIGITS ---
            else if (indicativo === "+975" || indicativo === "+267" || indicativo === "+501" || indicativo === "+674" || indicativo === "+686") {
                amountNumber = 7;
                maskara = "### ####";
            }

            // --- GLOBAL REGIONAL FALLBACKS ---
            else if (indicativo.startsWith("+3") || indicativo.startsWith("+4") || indicativo.startsWith("+5") || indicativo.startsWith("+6")) {
                amountNumber = 9;
                maskara = "### ### ###";
            }
            else if (indicativo.startsWith("+2") || indicativo.startsWith("+8") || indicativo.startsWith("+9")) {
                amountNumber = 9;
                maskara = "#########";
            }

            // --- MAXIMUM INTERNATIONAL SAFETY FALLBACK ---
            else {
                amountNumber = 15;
                maskara = "###############";
            }
        }



    // ============================================================
    // CLEAR DATA
    // ============================================================

    function clearPatientData()
    {
        nameValue.text = ""
        ageValue.currentIndex = -1
        reasonValue.text = ""
        phoneValue.text = ""

        durationValue.currentIndex = 0
        departmentValue.currentIndex = 0
        countryCode.currentIndex = 4

        patientInfoName = "-"
        patientInfoAge = "-"
        patientInfoReason = "-"
        patientInfoDuration = "-"
        patientInfoPhone = "-"
        patientInfoDepartment = "-"

        statusValue.text = "-"
    }

    // ============================================================
    // API
    // ============================================================

    Connections {
        target: mediFlowApi

        function onResultReceived(result)
        {
            loading = false

            console.log("Server response:", result)

            try
            {
                var data = JSON.parse(result)

                // ==========================================
                // ERROR FROM SERVER
                // ==========================================

                if (data.error)
                {
                    statusValue.text =
                        "Unable to process the request."

                    return
                }

                // ==========================================
                // PATIENT INFORMATION
                // ==========================================

                patientInfoName =
                    data.name || "-"

                patientInfoAge =
                    data.age !== undefined
                    ? String(data.age)
                    : "-"

                patientInfoReason =
                    data.reason || "-"

                patientInfoDuration =
                    data.duration || "-"

                patientInfoPhone =
                    data.phone || "-"

                // ==========================================
                // ROUTING
                // ==========================================

                if (data.routing &&
                    data.routing.department)
                {
                    patientInfoDepartment =
                        data.routing.department
                }
                else
                {
                    patientInfoDepartment = "-"
                }

                // ==========================================
                // VALIDATION
                // ==========================================

                if (data.validation &&
                    data.validation.valid === false)
                {
                    statusValue.text =
                        "INCOMPLETE — Please provide the missing information"

                    return
                }

                // ==========================================
                // VERIFICATION
                // ==========================================

                if (data.verification &&
                    data.verification.approved === true)
                {
                    statusValue.text =
                        "APPROVED ✓"
                }
                else
                {
                    statusValue.text =
                        "REJECTED ✗"
                }
            }
            catch(e)
            {
                statusValue.text =
                    "Unable to process the request."

                console.log("JSON error:", e)
                console.log("Server response:", result)
            }
        }

        function onErrorOccurred(error) {

            loading = false

            statusValue.text =
                "Unable to process the request. Please try again."

            console.log("API error:", error)
        }
    }

    // ============================================================
    // MAIN
    // ============================================================

    ColumnLayout {

        anchors.fill: parent
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

                        text:
                            "Healthcare Administrative Intake"

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

            ScrollBar.vertical.policy:
                ScrollBar.AsNeeded

            ColumnLayout {

                width: parent.width

                anchors.left: parent.left
                anchors.right: parent.right

                anchors.leftMargin: 35
                anchors.rightMargin: 35

                spacing: 22

                // =================================================
                // TITLE
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

                        text:
                            "Enter the patient's information below."

                        color: "#6b7280"

                        font.pixelSize: 14
                    }
                }

                // =================================================
                // PATIENT FORM
                // =================================================

                Rectangle {

                    Layout.fillWidth: true

                    Layout.preferredHeight: 460

                    radius: 16

                    color: "#ffffff"

                    border.width: 1
                    border.color: "#e4e8ef"

                    ColumnLayout {

                        anchors.fill: parent

                        anchors.margins: 24

                        spacing: 12

                        // -----------------------------------------
                        // NAME
                        // -----------------------------------------

                        Label {

                            text: "FULL NAME"

                            color: "#8993a5"

                            font.pixelSize: 10
                            font.bold: true
                        }

                        TextField {

                            id: nameValue

                            Layout.fillWidth: true

                            Layout.preferredHeight: 44

                            placeholderText:
                                "Enter patient's full name"

                            font.pixelSize: 14

                            color: "#172033"

                            leftPadding: 14
                            rightPadding: 14

                            validator:
                                RegularExpressionValidator {
                                    regularExpression:
                                        /^[A-Za-zÀ-ÿ]+([ '-][A-Za-zÀ-ÿ]+)*$/
                                }

                            background: Rectangle {

                                radius: 10

                                color: "#f8fafc"

                                border.width: 1

                                border.color:
                                    nameValue.activeFocus
                                    ? "#2563eb"
                                    : "#dfe4ec"
                            }
                        }

                        // -----------------------------------------
                        // AGE + PHONE
                        // -----------------------------------------

                        RowLayout {

                            Layout.fillWidth: true

                            spacing: 15

                            ColumnLayout {

                                Layout.preferredWidth: 20

                                spacing: 7

                                Label {

                                    text: "AGE"

                                    color: "#8993a5"

                                    font.pixelSize: 10
                                    font.bold: true
                                }

                                ComboBox {

                                    id: ageValue

                                        Layout.fillWidth: true
                                        Layout.preferredHeight: 44

                                        font.pixelSize: 14

                                        model: Array.from({length: 150}, (_, i) => i + 1)

                                        currentIndex: -1

                                        background: Rectangle {
                                            radius: 10
                                            color: "#f8fafc"

                                            border.width: 1
                                            border.color:
                                                ageValue.activeFocus
                                                ? "#2563eb"
                                                : "#dfe4ec"
                                        }
                                }
                            }

                            // -------------------------------------
                            // PHONE
                            // -------------------------------------

                            ColumnLayout {

                                Layout.fillWidth: true

                                spacing: 7

                                Label {

                                    text: "PHONE NUMBER (Preference Somebody next to the Patient - Family,Friend, College)"

                                    color: "#8993a5"

                                    font.pixelSize: 10
                                    font.bold: true
                                }

                                RowLayout {

                                    Layout.fillWidth: true

                                    spacing: 6

                                    ComboBox {

                                        id: countryCode

                                        Layout.preferredWidth: 220

                                        Layout.preferredHeight: 44

                                        currentIndex: 4

                                        font.pixelSize: 13

                                        model: [

                                            "Afghanistan (+93)",
                                            "Albania (+355)",
                                            "Algeria (+213)",
                                            "Andorra (+376)",
                                            "Angola (+244)",
                                            "Antigua and Barbuda (+1)",
                                            "Argentina (+54)",
                                            "Armenia (+374)",
                                            "Australia (+61)",
                                            "Austria (+43)",
                                            "Azerbaijan (+994)",
                                            "Bahamas (+1)",
                                            "Bahrain (+973)",
                                            "Bangladesh (+880)",
                                            "Barbados (+1)",
                                            "Belarus (+375)",
                                            "Belgium (+32)",
                                            "Belize (+501)",
                                            "Benin (+229)",
                                            "Bhutan (+975)",
                                            "Bolivia (+591)",
                                            "Bosnia and Herzegovina (+387)",
                                            "Botswana (+267)",
                                            "Brazil (+55)",
                                            "Brunei (+673)",
                                            "Bulgaria (+359)",
                                            "Burkina Faso (+226)",
                                            "Burundi (+257)",
                                            "Cabo Verde (+238)",
                                            "Cambodia (+855)",
                                            "Cameroon (+237)",
                                            "Canada (+1)",
                                            "Central African Republic (+236)",
                                            "Chad (+235)",
                                            "Chile (+56)",
                                            "China (+86)",
                                            "Colombia (+57)",
                                            "Comoros (+269)",
                                            "Congo (+242)",
                                            "Costa Rica (+506)",
                                            "Croatia (+385)",
                                            "Cuba (+53)",
                                            "Cyprus (+357)",
                                            "Czech Republic (+420)",
                                            "Democratic Republic of the Congo (+243)",
                                            "Denmark (+45)",
                                            "Djibouti (+253)",
                                            "Dominica (+1)",
                                            "Dominican Republic (+1)",
                                            "Ecuador (+593)",
                                            "Egypt (+20)",
                                            "El Salvador (+503)",
                                            "Equatorial Guinea (+240)",
                                            "Eritrea (+291)",
                                            "Estonia (+372)",
                                            "Eswatini (+268)",
                                            "Ethiopia (+251)",
                                            "Fiji (+679)",
                                            "Finland (+358)",
                                            "France (+33)",
                                            "Gabon (+241)",
                                            "Gambia (+220)",
                                            "Georgia (+995)",
                                            "Germany (+49)",
                                            "Ghana (+233)",
                                            "Greece (+30)",
                                            "Grenada (+1)",
                                            "Guatemala (+502)",
                                            "Guinea (+224)",
                                            "Guinea-Bissau (+245)",
                                            "Guyana (+592)",
                                            "Haiti (+509)",
                                            "Honduras (+504)",
                                            "Hungary (+36)",
                                            "Iceland (+354)",
                                            "India (+91)",
                                            "Indonesia (+62)",
                                            "Iran (+98)",
                                            "Iraq (+964)",
                                            "Ireland (+353)",
                                            "Israel (+972)",
                                            "Italy (+39)",
                                            "Ivory Coast (+225)",
                                            "Jamaica (+1)",
                                            "Japan (+81)",
                                            "Jordan (+962)",
                                            "Kazakhstan (+7)",
                                            "Kenya (+254)",
                                            "Kiribati (+686)",
                                            "Kuwait (+965)",
                                            "Kyrgyzstan (+996)",
                                            "Laos (+856)",
                                            "Latvia (+371)",
                                            "Lebanon (+961)",
                                            "Lesotho (+266)",
                                            "Liberia (+231)",
                                            "Libya (+218)",
                                            "Liechtenstein (+423)",
                                            "Lithuania (+370)",
                                            "Luxembourg (+352)",
                                            "Madagascar (+261)",
                                            "Malawi (+265)",
                                            "Malaysia (+60)",
                                            "Maldives (+960)",
                                            "Mali (+223)",
                                            "Malta (+356)",
                                            "Marshall Islands (+692)",
                                            "Mauritania (+222)",
                                            "Mauritius (+230)",
                                            "Mexico (+52)",
                                            "Micronesia (+691)",
                                            "Moldova (+373)",
                                            "Monaco (+377)",
                                            "Mongolia (+976)",
                                            "Montenegro (+382)",
                                            "Morocco (+212)",
                                            "Mozambique (+258)",
                                            "Myanmar (+95)",
                                            "Namibia (+264)",
                                            "Nauru (+674)",
                                            "Nepal (+977)",
                                            "Netherlands (+31)",
                                            "New Zealand (+64)",
                                            "Nicaragua (+505)",
                                            "Niger (+227)",
                                            "Nigeria (+234)",
                                            "North Korea (+850)",
                                            "North Macedonia (+389)",
                                            "Norway (+47)",
                                            "Oman (+968)",
                                            "Pakistan (+92)",
                                            "Palau (+680)",
                                            "Palestine (+970)",
                                            "Panama (+507)",
                                            "Papua New Guinea (+675)",
                                            "Paraguay (+595)",
                                            "Peru (+51)",
                                            "Philippines (+63)",
                                            "Poland (+48)",
                                            "Portugal (+351)",
                                            "Qatar (+974)",
                                            "Romania (+40)",
                                            "Russia (+7)",
                                            "Rwanda (+250)",
                                            "Saint Kitts and Nevis (+1)",
                                            "Saint Lucia (+1)",
                                            "Saint Vincent and the Grenadines (+1)",
                                            "Samoa (+685)",
                                            "San Marino (+378)",
                                            "Sao Tome and Principe (+239)",
                                            "Saudi Arabia (+966)",
                                            "Senegal (+221)",
                                            "Serbia (+381)",
                                            "Seychelles (+248)",
                                            "Sierra Leone (+232)",
                                            "Singapore (+65)",
                                            "Slovakia (+421)",
                                            "Slovenia (+386)",
                                            "Solomon Islands (+677)",
                                            "Somalia (+252)",
                                            "South Africa (+27)",
                                            "South Korea (+82)",
                                            "South Sudan (+211)",
                                            "Spain (+34)",
                                            "Sri Lanka (+94)",
                                            "Sudan (+249)",
                                            "Suriname (+597)",
                                            "Sweden (+46)",
                                            "Switzerland (+41)",
                                            "Syria (+963)",
                                            "Taiwan (+886)",
                                            "Tajikistan (+992)",
                                            "Tanzania (+255)",
                                            "Thailand (+66)",
                                            "Timor-Leste (+670)",
                                            "Togo (+228)",
                                            "Tonga (+676)",
                                            "Trinidad and Tobago (+1)",
                                            "Tunisia (+216)",
                                            "Turkey (+90)",
                                            "Turkmenistan (+993)",
                                            "Tuvalu (+688)",
                                            "Uganda (+256)",
                                            "Ukraine (+380)",
                                            "United Arab Emirates (+971)",
                                            "United Kingdom (+44)",
                                            "United States (+1)",
                                            "Uruguay (+598)",
                                            "Uzbekistan (+998)",
                                            "Vanuatu (+678)",
                                            "Vatican City (+39)",
                                            "Venezuela (+58)",
                                            "Vietnam (+84)",
                                            "Yemen (+967)",
                                            "Zambia (+260)",
                                            "Zimbabwe (+263)"
                                        ]

                                        background: Rectangle {

                                            radius: 10

                                            color: "#f8fafc"

                                            border.width: 1

                                            border.color:
                                                countryCode.activeFocus
                                                ? "#2563eb"
                                                : "#dfe4ec"
                                        }
                                        onActivated: {aplicarMascaraPorPais(countryCode.currentText)}
                                    }

                                    TextField {

                                        id: phoneValue

                                        Layout.fillWidth: true

                                        Layout.preferredHeight: 44


                                        placeholderText: maskara
                                        maximumLength: amountNumber
                                        font.pixelSize: 14

                                        color: "#172033"

                                        inputMethodHints:
                                            Qt.ImhDigitsOnly

                                        validator:
                                            RegularExpressionValidator {
                                                regularExpression:
                                                    /^[0-9]{6,15}$/
                                            }

                                        background: Rectangle {

                                            radius: 10

                                            color: "#f8fafc"

                                            border.width: 1

                                            border.color:
                                                phoneValue.activeFocus
                                                ? "#2563eb"
                                                : "#dfe4ec"
                                        }
                                    }
                                }
                            }
                        }

                        // -----------------------------------------
                        // REASON
                        // -----------------------------------------

                        Label {

                            text: "REASON FOR VISIT"

                            color: "#8993a5"

                            font.pixelSize: 10
                            font.bold: true
                        }

                        TextField {

                            id: reasonValue

                            Layout.fillWidth: true

                            Layout.preferredHeight: 44

                            placeholderText:
                                "e.g. Headache, fever, stomach pain..."

                            font.pixelSize: 14

                            color: "#172033"

                            leftPadding: 14
                            rightPadding: 14

                            background: Rectangle {

                                radius: 10

                                color: "#f8fafc"

                                border.width: 1

                                border.color:
                                    reasonValue.activeFocus
                                    ? "#2563eb"
                                    : "#dfe4ec"
                            }
                        }

                        // -----------------------------------------
                        // DURATION + DEPARTMENT
                        // -----------------------------------------

                        RowLayout {

                            Layout.fillWidth: true

                            spacing: 15

                            ColumnLayout {

                                Layout.fillWidth: true

                                spacing: 7

                                Label {

                                    text: "DURATION"

                                    color: "#8993a5"

                                    font.pixelSize: 10
                                    font.bold: true
                                }

                                ComboBox {

                                    id: durationValue

                                    Layout.fillWidth: true

                                    Layout.preferredHeight: 44

                                    model: [
                                        "Today",
                                        "2 days",
                                        "3 days",
                                        "4 days",
                                        "5 days",
                                        "1 week",
                                        "2 weeks",
                                        "1 month",
                                        "More than 1 month"
                                    ]

                                    background: Rectangle {

                                        radius: 10

                                        color: "#f8fafc"

                                        border.width: 1

                                        border.color:
                                            durationValue.activeFocus
                                            ? "#2563eb"
                                            : "#dfe4ec"
                                    }
                                }
                            }
                        }

                        // -----------------------------------------
                        // SEND
                        // -----------------------------------------

                        RowLayout {

                            Layout.fillWidth: true

                            Item {
                                Layout.fillWidth: true
                            }

                            Label {

                                visible: loading

                                text:
                                    "Processing patient information..."

                                color: "#6b7280"

                                font.pixelSize: 12
                            }

                            Button {

                                id: sendButton

                                Layout.preferredWidth: 135

                                Layout.preferredHeight: 44

                                enabled:
                                    !loading &&
                                    nameValue.text.trim().length > 2 &&
                                    ageValue.currentIndex > 0 &&
                                    reasonValue.text.trim().length > 2 &&
                                    phoneValue.text.length >= 6

                                text:
                                    loading
                                    ? "SENDING..."
                                    : "SEND"

                                font.pixelSize: 13
                                font.bold: true

                                contentItem: Label {

                                    text: sendButton.text

                                    color:
                                        sendButton.enabled
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

                                    patientInfoName = "-"
                                    patientInfoAge = "-"
                                    patientInfoReason = "-"
                                    patientInfoDuration = "-"
                                    patientInfoPhone = "-"
                                    patientInfoDepartment = "-"
                                    statusValue.text = "-"
                                    loading = true

                                    var code =
                                        countryCode.currentText

                                    code =
                                        code.substring(
                                            code.indexOf("(") + 1,
                                            code.indexOf(")")
                                        )

                                    patientInfoName =
                                        nameValue.text.trim()

                                    patientInfoAge =
                                        ageValue.currentText.trim()

                                    patientInfoReason =
                                        reasonValue.text.trim()

                                    patientInfoDuration =
                                        durationValue.currentText

                                    patientInfoPhone =
                                        code + " " +
                                    phoneValue.text.trim()

                                    var patientMessage =
                                        "Patient information:\n" +
                                        "Name: " +
                                        nameValue.text.trim() + "\n" +
                                        "Age: " +
                                        ageValue.currentText.trim() + "\n" +
                                        "Phone: (" + code + ") " +
                                        phoneValue.text.trim() + "\n" +
                                        "Reason: " +
                                        reasonValue.text.trim() + "\n" +
                                        "Duration: " +
                                        durationValue.currentText + "\n"

                                    console.log(patientMessage)

                                    mediFlowApi.sendMessage(
                                        patientMessage
                                    )
                                }
                            }
                        }
                    }
                }

                // =================================================
                // PATIENT INFORMATION
                // =================================================

                Rectangle {

                    Layout.fillWidth: true

                    Layout.preferredHeight: 260

                    radius: 16

                    color: "#ffffff"

                    border.width: 1
                    border.color: "#e4e8ef"

                    ColumnLayout {

                        anchors.fill: parent

                        anchors.margins: 24

                        spacing: 16

                        RowLayout {

                            Layout.fillWidth: true

                            Label {

                                text: "Patient Information"

                                color: "#172033"

                                font.pixelSize: 20
                                font.bold: true
                            }

                            Item {
                                Layout.fillWidth: true
                            }

                            Label {

                                text: "PROCESSED"

                                color: "#2563eb"

                                font.pixelSize: 10
                                font.bold: true
                            }
                        }

                        Rectangle {

                            Layout.fillWidth: true

                            Layout.preferredHeight: 1

                            color: "#e5e9f0"
                        }

                        GridLayout {

                            Layout.fillWidth: true

                            columns: 2

                            rowSpacing: 16
                            columnSpacing: 35

                            // NAME

                            ColumnLayout {

                                Layout.fillWidth: true

                                spacing: 4

                                Label {

                                    text: "FULL NAME"

                                    color: "#8993a5"

                                    font.pixelSize: 10
                                    font.bold: true
                                }

                                Label {

                                    text: patientInfoName

                                    color: "#172033"

                                    font.pixelSize: 14
                                    font.bold: true

                                    elide:
                                        Text.ElideRight

                                    Layout.fillWidth: true
                                }
                            }

                            // AGE

                            ColumnLayout {

                                Layout.fillWidth: true

                                spacing: 4

                                Label {

                                    text: "AGE"

                                    color: "#8993a5"

                                    font.pixelSize: 10
                                    font.bold: true
                                }

                                Label {

                                    text: patientInfoAge

                                    color: "#172033"

                                    font.pixelSize: 14
                                    font.bold: true
                                }
                            }

                            // REASON

                            ColumnLayout {

                                Layout.fillWidth: true

                                spacing: 4

                                Label {

                                    text: "REASON"

                                    color: "#8993a5"

                                    font.pixelSize: 10
                                    font.bold: true
                                }

                                Label {

                                    text: patientInfoReason

                                    color: "#172033"

                                    font.pixelSize: 14

                                    elide:
                                        Text.ElideRight

                                    Layout.fillWidth: true
                                }
                            }

                            // DURATION

                            ColumnLayout {

                                Layout.fillWidth: true

                                spacing: 4

                                Label {

                                    text: "DURATION"

                                    color: "#8993a5"

                                    font.pixelSize: 10
                                    font.bold: true
                                }

                                Label {

                                    text: patientInfoDuration

                                    color: "#172033"

                                    font.pixelSize: 14
                                }
                            }

                            // PHONE

                            ColumnLayout {

                                Layout.fillWidth: true

                                spacing: 4

                                Label {

                                    text: "PHONE"

                                    color: "#8993a5"

                                    font.pixelSize: 10
                                    font.bold: true
                                }

                                Label {

                                    text: patientInfoPhone

                                    color: "#172033"

                                    font.pixelSize: 14
                                }
                            }

                            // DEPARTMENT

                            ColumnLayout {

                                Layout.fillWidth: true

                                spacing: 4

                                Label {

                                    text: "DEPARTMENT"

                                    color: "#8993a5"

                                    font.pixelSize: 10
                                    font.bold: true
                                }

                                Label {

                                    text: patientInfoDepartment

                                    color: "#2563eb"

                                    font.pixelSize: 14
                                    font.bold: true
                                }
                            }
                        }
                    }
                }

                // =================================================
                // STATUS
                // =================================================

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

                // =================================================
                // FOOTER
                // =================================================

                Label {

                    Layout.fillWidth: true

                    Layout.bottomMargin: 25

                    text:
                        "MediFlow AI • Administrative healthcare assistance"

                    color: "#9aa3b2"

                    font.pixelSize: 11

                    horizontalAlignment:
                        Text.AlignHCenter
                }
            }
        }
    }
}