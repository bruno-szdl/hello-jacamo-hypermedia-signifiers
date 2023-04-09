+!load_ontologies
    : 
        true
    <-
        // .setof(Ontology, (hasAction(Ontology,_) | isOfType(Ontology,_)), Ontologies);
        Ontologies = ["https://saref.etsi.org/core", "https://raw.githubusercontent.com/bruno-szdl/example_ont_companies/main/companyA.owl", "https://raw.githubusercontent.com/bruno-szdl/example_ont_companies/main/companyB.owl"]

        for ( .member(Ontology, Ontologies) ){
            makeArtifact(Ontology, "pucrs.smart.ontology.mas.OntologyArtifact", [Ontology], OntId);
            focusWhenAvailable(Ontology);
        };
        .

+!get_subsumption_relations
    : 
        true
    <-
        // .setof(Ontology, focused(_, Ontology [artifact_type("pucrs.smart.ontology.mas.OntologyArtifact")],_)[source(percept)], Ontologies);
        Ontologies = ["https://saref.etsi.org/core", "https://raw.githubusercontent.com/bruno-szdl/example_ont_companies/main/companyA.owl", "https://raw.githubusercontent.com/bruno-szdl/example_ont_companies/main/companyB.owl"]
        .setof(class(Ont, Class), hasAction(Ont, Class), Classes);

        for ( .member(Ontology, Ontologies) ) {

            for ( .member(class(SuperOnt, SuperClass), Classes) ) {
                .concat(SuperOnt, "#", SuperClass, SuperUri);

                for ( .member(class(SubOnt, SubClass), Classes) ) {
                    .concat(SubOnt, "#", SubClass, SubUri);
                    isSubConcept(SubUri, SuperUri, Bool)[artifact_name(Ontology)]

                    if (Bool) {
                        +isSubConceptOf(SubUri, SuperUri);
                    }
                }
            }
        }
        .

