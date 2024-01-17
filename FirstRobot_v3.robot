*** Settings ***
Documentation       Ceci est un cas de test automatisé.
Library    SeleniumLibrary
Test Setup    Slow execution
Test Teardown    End of Test and Close browser

*** Variables ***
${url}    https://katalon-demo-cura.herokuapp.com
${browser}    firefox
${facility}    Hongkong CURA Healthcare Center
${readmission}    true
${program}    Medicaid
${visitDate}    02/07/2022
${comment}    un commentaire

#Variable de vérification de l'attendu
${readmissionExpected}    Yes

#JDD
&{JDD1}    facility=Tokyo CURA Healthcare Center    program=Medicare
&{JDD2}    facility=Hongkong CURA Healthcare Center    program=Medicaid
&{JDD3}    facility=Seoul CURA Healthcare Center    program=none

*** Keywords ***
Slow execution
    #On ralentit l'exécution pour chaque nouvelle action
    Set Selenium Implicit Wait    2 seconds
Open browser to Login Page
    #### Parcours de connexion ####
    #Ouvrir le navigateur
    Open Browser    ${url}   ${browser}
    #Fenêtre en plein écran
    Maximize Browser Window  
Login to Book Appointment
    [Arguments]    ${login}    ${password}    ${facility}    ${program}
    #Accéder au formulaire de connexion
    Click Element    id:btn-make-appointment
    #Remplir les champs du formulaire
    Input Text    name:username    ${login}
    Input Text    name:password    ${password}
    #Bouton Se connecter
    Click Button  id:btn-login  #xpath=//button[@id="btn-login"]
Book Appointment
    #### Formulaire appointment ####
    #Sélectionner une facility
    Element Should Be Visible    id:combo_facility
    Click Element    id:combo_facility
    Select From List By Value    id:combo_facility    ${facility}
    #Cocher Apply readmission et un programme
    Element Should Be Visible    id:chk_hospotal_readmission
    Select Checkbox    id:chk_hospotal_readmission
    Select Radio Button    programs    ${program}
    # Remplir Visit date
    Input Text    id:txt_visit_date    ${visitDate}
    #Entrer un commentaire
    Input Text    id:txt_comment    ${comment}
    #Bouton Book appointment
    Click Button    id:btn-book-appointment

    #### Vérification des sorties ####
    Element Should Be Visible     id:facility
    Element Should Be Visible    id:hospital_readmission
    Element Should Be Visible    id:program
    Element Should Be Visible    id:visit_date
    Element Should Be Visible    id:comment

    Element Text Should Be    id:facility    ${facility}
    Element Text Should Be    id:hospital_readmission    ${readmissionExpected}
    Element Text Should Be    id:program    ${program}
    Element Text Should Be    id:visit_date    ${visitDate}
    Element Text Should Be    id:comment    ${comment}

End of Test and Close browser
    #### Freeze puis fermeture du navigateur ####
    Sleep    5
    Close Browser


*** Test Cases ***
Login Page test
    Open browser to Login Page
    End of Test and Close browser

#Cas passant
Book appointment test with existing user 
    Open browser to Login Page
    Login to Book Appointment    John Doe    ThisIsNotAPassword    &{JDD1}{facility}    &{JDD2}{program}
    Book Appointment

#Cas non-passant
Book appointment test with existing user 
    Slow execution
    Open browser to Login Page
    Login to Book Appointment    yolo    yolo    &{JDD2}{facility}    &{JDD3}{program}
    Book Appointment



    