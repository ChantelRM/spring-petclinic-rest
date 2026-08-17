import io.restassured.RestAssured;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

public class OwnerApiTest {
    @BeforeAll
    static void setUp() {
        // This runs ONCE before any test in this class, not before each individual test.
        // It tells REST Assured where the running PetClinic app lives, so every
        // test below doesn't have to repeat the full URL.
        RestAssured.baseURI = "http://localhost:9966"; // adjust to your actual host/port
        RestAssured.basePath = "/petclinic/api/v1";     // adjust to match your app's actual base path
    }

    @Test
    @DisplayName("Create owner with valid data returns 201")
    void createOwner_withValidData_returns201() {
        // TODO: implement using given().body(...).when().post("/owners").then().statusCode(201);
    }

    @Test
    @DisplayName("Create owner with missing lastName returns 400")
    void createOwner_missingLastName_returns400() {
        // TODO
    }

    @Test
    @DisplayName("Create owner with empty firstName returns 400")
    void createOwner_emptyFirstName_returns400() {
        // TODO
    }

    @Test
    @DisplayName("Create owner with null city returns 400")
    void createOwner_nullCity_returns400() {
        // TODO
    }

    @Test
    @DisplayName("Create owner with telephone at max boundary length returns 201")
    void createOwner_telephoneAtMaxLength_returns201() {
        // TODO
    }

    @Test
    @DisplayName("Create owner with telephone over max length returns 400")
    void createOwner_telephoneOverMaxLength_returns400() {
        // TODO
    }

    @Test
    @DisplayName("Get owner with non-existent id returns 404")
    void getOwner_nonExistentId_returns404() {
        // TODO
    }

    @Test
    @DisplayName("Update owner with valid data returns 200")
    void updateOwner_withValidData_returns200() {
        // TODO
    }
}