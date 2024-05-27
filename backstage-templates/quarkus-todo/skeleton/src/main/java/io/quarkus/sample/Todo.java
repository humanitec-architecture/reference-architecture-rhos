package io.quarkus.sample;

import io.quarkus.hibernate.orm.panache.PanacheEntity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.validation.constraints.NotBlank;
import java.util.List;

import org.eclipse.microprofile.openapi.annotations.media.Schema;

@Entity
public class Todo extends PanacheEntity {

    @NotBlank
    @Column(unique = true)
    public String title;

    public boolean completed;

    @Column(name = "ordering")
    public int order;

    @Schema(example = "https://github.com/quarkusio/todo-demo-app")
    public String url;

    public static List<Todo> findNotCompleted() {
        return list("completed", false);
    }

    public static List<Todo> findCompleted() {
        return list("completed", true);
    }

    public static long deleteCompleted() {
        return delete("completed", true);
    }

}
