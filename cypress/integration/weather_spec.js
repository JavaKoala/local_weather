describe('Weather retrieval', function() {
  it('returns the weather for New York', function() {
    cy.visit('/');
    cy.get('#city-input').type('New York');
    cy.get('#state-input').select('New York');
    cy.get('.btn').contains('Get forecast').click();

    // Test forecast
    cy.get('td[aria-colindex=1]').contains('Tonight');
    cy.get('td[aria-colindex=1]').should('have.length', 14);
    cy.get('td[aria-colindex=2]').first().should('not.be.empty');
    cy.get('td[aria-colindex=3]').first().should('have.text', 'F');
    cy.get('td[aria-colindex=4]').first().should('not.be.empty');

    // Test caching
    cy.get('.btn').contains('Get forecast').click();
    cy.get('p').contains('Cache hit: true');
  })
})
