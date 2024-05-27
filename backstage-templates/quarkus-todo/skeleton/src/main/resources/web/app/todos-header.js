import {LitElement, css, html} from 'lit';
import '@vaadin/icon';
import '@vaadin/vaadin-lumo-styles/vaadin-iconset.js';
import '@vaadin/icons';

class TodosHeader extends LitElement {
  static styles = css`
        :host {
            display: flex;
            justify-content: center;
            font-size: 100px;
            line-height: 100px;
            height: 100px;
            font-weight: 100;
            padding-top: 20px;
            padding-bottom: 20px;
        }
        
        .title {
            align-self: baseline;
            padding-left: 20px;
        }
        .logo {
            align-self: baseline;
            width: 64px;
            height: 64px;
        }
        .theme-switch {
            height: 25px;
            position: absolute;
            right: 10px;
            cursor: pointer;
        }
    `;
    static properties = {
        _nextTheme: {state: true},
        _currentTheme: {state: true},
    }

    constructor() {
        super();
        this._currentTheme = "dark";
        this._nextTheme = "light";
    }

    render() {
      return html`<img class="logo" src="static/quarkus_icon_${this._currentTheme}.png"> <span class="title">todos</span>
                    <vaadin-icon title="Switch to ${this._nextTheme} theme" class="theme-switch" icon="vaadin:adjust" @click="${this._switchTheme}"></vaadin-icon>
              `;
    }

    _switchTheme(){
          const body = document.body;
          if (body.getAttribute('theme') === 'light') {
              this._nextTheme = "light";
              this._currentTheme = "dark";
              body.setAttribute('theme', 'dark');
          } else {
              this._nextTheme = "dark";
              this._currentTheme = "light";
              body.setAttribute('theme', 'light');
          }
    }
}
customElements.define('todos-header', TodosHeader);