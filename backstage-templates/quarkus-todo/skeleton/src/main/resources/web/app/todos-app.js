import {LitElement, html, css} from 'lit';

import './todos-header.js';
import './todos-cards.js';
import './todos-footer.js';

class TodosApp extends LitElement {

    static styles = css`
        :host {
            display: flex;
            flex-direction: column;
            width: 100vw;
            height: 100vh;
            justify-content: space-between;
            overflow: hidden;
        }
        .center {
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
        }
    `;    
    
    render() {
        return html`<div class="center">
                        <todos-header></todos-header>
                        <todos-cards></todos-cards>
                    </div>
                    <todos-footer></todos-footer>
          `;
    }
}
customElements.define('todos-app', TodosApp);