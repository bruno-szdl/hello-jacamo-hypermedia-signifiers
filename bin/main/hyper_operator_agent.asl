/* Initial beliefs and rules */

// URL of the smartbuilding
env_url("http://192.168.15.8:8080/environments/smartbuilding/").

!start.

/* Plans */

+!start
    :
        env_url(Url)
    <-
        makeArtifact("notification-server", "ch.unisg.ics.interactions.jacamo.artifacts.yggdrasil.NotificationServerArtifact", ["localhost", 8081], _);

        // Loading environment
        print("############# Loading environment #############\n");
        !load_environment("smartbuilding", Url);
        .wait(1000);
        .print("[Load environment] Finished loading the environment \n\n");

        // Loading ontologies
        print("############# Loading ontologies #############\n");
        !load_ontologies;
        .wait(200);
        .print("[Load Ontologies] Finished loading the ontologies \n\n");

        // Getting subsumption relations between classes
        print("############# Getting subsumption relations  #############\n");
        !get_subsumption_relations;
        .wait(200);
        .print("[Get Subsumption relations] Finished getting subsumption relations \n\n");

        // performing desired action
        print("############# Trying to Switch on lights #############\n");
        !performDesiredAction("LightSwitch", "https://saref.etsi.org/core#ToggleCommand", "meetingroom");

        print("############# Trying to Switch on smarttv #############\n");
        !performDesiredAction("Smarttv", "https://saref.etsi.org/core#ToggleCommand", "meetingroom");
        .


+!performDesiredAction(ThingType, DesiredAction, WorkspaceName)
    : 
        .count(isOfType(_, ThingType), N)
        & N > 0
    <-
        joinWorkspace(WorkspaceName, WorkspaceArtId);
        .print("[PerformDesiredAction] Joining workspace: ", WorkspaceName);

        .term2string(WorkspaceNameAtom, WorkspaceName);
        .setof(
            ThingNameAtom
            , isOfType(_,ThingType)[_,artifact_name(_,ThingNameAtom),_,_,_]
                & .term2string(ThingNameAtom, ThingName)
                & artifact(_, ThingName)[_,_,_,_,workspace(_,WorkspaceNameAtom,_)]
            , ThingNames);

        for ( .member(ThingNameAtom, ThingNames) ) {
            .term2string(ThingNameAtom, ThingName)
            .print("\n[PerformDesiredAction] Toggling ", ThingType);
            !performApplicableAction(ThingName, DesiredAction);
        }
        .print("\n[PerformDesiredAction] Switched on lights! \n\n");
        .

+!performDesiredAction(ThingType, DesiredAction, WorkspaceName)
    : 
        true
    <-
        .print("[PerformDesiredAction] There is no thing of type ", ThingType);
        .


+!performApplicableAction(ThingName, DesiredAction)
    :
        .term2string(ThingNameAtom, ThingName)
        & hasAction(Ont, Action)[_,artifact_name(_,ThingNameAtom),_,_,_]
        & .concat(Ont, "#", Action, ApplicableAction)
        & ApplicableAction = DesiredAction
    <-
        .print("[PerformApplicableAction]", "Executing action '", ApplicableAction, "' in  '", ThingName);
        invokeAction(ApplicableAction, ["https://www.w3.org/2019/wot/json-schema#BooleanSchema"], [true])[artifact_name(ThingName)]
        .

+!performApplicableAction(ThingName, DesiredAction)
    : 
        .term2string(ThingNameAtom, ThingName)
        & hasAction(Ont, Action)[_,artifact_name(_,ThingNameAtom),_,_,_]
        & .concat(Ont, "#", Action, ApplicableAction)
        & isSubConceptOf(ApplicableAction, DesiredAction)
    <-
        .print("[PerformApplicableAction]", "Executing action '", ApplicableAction, "' in  '", ThingName);
        invokeAction("https://saref.etsi.org/core#ToggleCommand", ["https://www.w3.org/2019/wot/json-schema#BooleanSchema"], [true])[artifact_name(ThingName)]
        .

+!performApplicableAction(ThingName, DesiredAction)
    : 
        true
    <-
        .print("[PerformApplicableAction]", ThingName, ": No action found for ", DesiredAction);
        .

{ include("inc/hypermedia.asl") }
{ include("inc/ontologies.asl") }
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }