import {LitElement, css, html} from 'lit';
import '@vaadin/horizontal-layout';

class TodosFooter extends LitElement {
    static styles = css`
        footer, footer a {
            color: var(--lumo-contrast-70pct);
            font-size: 10px;
        }
    `;
    
    render() {
        return html`
            <footer>
                <vaadin-horizontal-layout theme="spacing-xs padding" style="justify-content: center">
                    <a href="/q/health" target="_blank" class="info">Health</a> .
                    <a href="/q/swagger-ui" target="_blank">OpenAPI</a> .
                    <a href="/q/graphql-ui" target="_blank">GraphQL</a>
                </vaadin-horizontal-layout>

            </footer>
        `;
    }
}
customElements.define('todos-footer', TodosFooter);
