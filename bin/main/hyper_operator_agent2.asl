/* Initial beliefs and rules */


//env_url("http://192.168.15.8:8080/environments/smartbuilding/").

//Pretending the agent read the .ttls and find out the actions afforded by the lightbulbs
hasAction("lightbulb1", "https://w3id.org/saref#ToggleCommand").
hasAction("lightbulb2", "https://w3id.org/saref#ToggleCommand").
hasAction("lightbulb3", "https://raw.githubusercontent.com/bruno-szdl/example_ont_companies/main/companyA.owl#toggleLight").
hasAction("lightbulb4", "https://raw.githubusercontent.com/bruno-szdl/example_ont_companies/main/companyB.owl#lightToggle").

//The agent can say that an action is equivalent to itself
is_equivalent("https://w3id.org/saref#ToggleCommand", "https://w3id.org/saref#ToggleCommand").

//Pretending the agent consulted the ontology and found out that Toggle Command subsumes toggleLight and lightToggle
subsumes("https://w3id.org/saref#ToggleCommand", "https://raw.githubusercontent.com/bruno-szdl/example_ont_companies/main/companyA.owl#toggleLight").
subsumes("https://w3id.org/saref#ToggleCommand", "https://raw.githubusercontent.com/bruno-szdl/example_ont_companies/main/companyB.owl#lightToggle").

//Rule to find out if object can afford an inferred action
hasInferredAction(Object, InferredAction) :- hasAction(Object, InferredAction) | (hasAction(Object, Action) & subsumes(InferredAction, Action)).

!start.

/* Plans */

+!start
    // :
        // env_url(Url)
    <-
        .print("hello world.");
        //makeArtifact("notification-server", "ch.unisg.ics.interactions.jacamo.artifacts.yggdrasil.NotificationServerArtifact", ["localhost", 8081], _);
        //!load_environment("smartbuilding", Url);
        // .wait(2000);
        // .print("finished loading the environment");
        !switchOnLights;
        .

+!switchOnLights
    <-
        .print("Switching on lights");
        !switchOnLight("lightbulb1", "https://w3id.org/saref#ToggleCommand");
        !switchOnLight("lightbulb2", "https://w3id.org/saref#ToggleCommand");
        !switchOnLight("lightbulb3", "https://w3id.org/saref#ToggleCommand");
        !switchOnLight("lightbulb4", "https://w3id.org/saref#ToggleCommand");
        .print("Switched on lights!");
        .

+!switchOnLight(Lightbulb, DesiredAction)
    :
        hasInferredAction(Lightbulb, DesiredAction)
        & (subsumes(DesiredAction, X) | is_equivalent(DesiredAction, X))
        & hasAction(Lightbulb, X)
    <-
        .print(Lightbulb, ": Executing action: ", X);
        //invokeAction(X, ["https://www.w3.org/2019/wot/json-schema#BooleanSchema"], [true])[artifact_name(Lightbulb)]
        .

+!switchOnLight(Lightbulb, DesiredAction)
    <-
        .print(Lightbulb, ": No applicable action found");
        .

{ include("inc/hypermedia.asl") }
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }