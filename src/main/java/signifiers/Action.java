package signifiers;

import java.util.Objects;
import jason.asSyntax.Term;

public class Action {
    Term name;
    Term resource;
    Term namespace;
    Term schema;

    /* Constructor */
    public Action(Term name, Term resource, Term namespace, Term schema){
        this.name = name;
        this.resource = resource;
        this.namespace = namespace;
        this.schema = schema;
    }

    /* Sets */
    public void setName(Term newName){
        name = newName;
    }

    public void setResource(Term newResource){
        resource = newResource;
    }

    public void setNamespace(Term newNamespace){
        namespace = newNamespace;
    }

    public void setSchema(Term newSchema){
        schema = newSchema;
    }

    /* Gets */
    public Term getName(){
        return name;
    }

    public Term getResource(){
        return resource;
    }

    public Term getNamespace(){
        return namespace;
    }

    public Term getSchema(){
        return schema;
    }

    /* Equals */
    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }

        if (!(obj instanceof Action)) {
            return false;
        }

        Action other = (Action) obj;

        return name.equals(other.name) && resource.equals(other.resource) && namespace.equals(other.namespace) && schema.equals(other.schema);
        // return name.equals(other.name);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, resource, namespace, schema);
    }

    @Override
    public String toString() {
        return resource.toString() + "." + name.toString() + "(" + namespace.toString() + ", " + schema.toString() + ")";
    }
}