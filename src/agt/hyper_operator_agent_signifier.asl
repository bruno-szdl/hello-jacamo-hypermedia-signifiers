// Version 3: The agent knows the actions the Things afford through signifiers.
//            The agent has a different behaviour for selecting the plan.
//            Now the agent enters the plan only if the action is available.
//            The developer don't need to check it.

/* Initial beliefs and rules */

// URL of the smartbuilding
hypermedia_artifact_desc("my_string").


+!start
    :
        hypermedia_artifact_desc(Url)
    <-
        makeArtifact("my_artifact", "ch.unisg.ics.interactions.hmas.interaction.artifact.HypermediaArtifact", [Url], _);
        .

{ include("inc/hypermedia.asl") }
{ include("inc/ontologies.asl") }
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }