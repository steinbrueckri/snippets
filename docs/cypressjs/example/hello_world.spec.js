describe("Hello World!", () => {

  it("Opened google.com", () => {
    cy.log("Visit google");
    cy.visit("https://google.com" + "/");
    cy.url()
      .should("eq", "https://www.google.com/")
      .wait(1000);
  });

  it("Search", () => {
    cy.get('input[name="q"]')
      .click()
      .wait(100)
      .clear()
      .type("cypress IS awsome!{enter}")
  });

  it("look for github.com and Javascript", () => {
    cy.get('body')
      .contains('github.com')
    cy.get('body')
      .contains('JavaScript')
  });

})
