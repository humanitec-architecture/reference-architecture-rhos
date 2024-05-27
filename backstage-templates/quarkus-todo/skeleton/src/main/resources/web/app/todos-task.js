import {LitElement, html, css} from 'lit';
import '@vaadin/icon';
import '@vaadin/vaadin-lumo-styles/vaadin-iconset.js';
import '@vaadin/icons';

class TodosTask extends LitElement {
    static styles = css`
        .item {
            display: flex;
            justify-content:space-between;
            font-size: 24px;
            font-weight: 300;
            width: 100%;
            gap: 20px;
        }
        .done-icon {
            color: var(--lumo-success-color-50pct);
            cursor: pointer;
            padding-left: 5px;
        }
        .outstanding-icon {
            color: var(--lumo-contrast-30pct);
            cursor: pointer;
            padding-left: 5px;
        }
        .done-text {
            text-decoration: line-through;
            color: var(--lumo-contrast-50pct);
        }
        .delete-icon {
            color: var(--lumo-error-color);
            cursor: pointer;
            padding-right: 5px;
        }
    
        .hide {
            visibility:hidden;
        }
    `;
    
    static properties = {
        id: {type: Number},
        task: {type: String},
        done: {type: Boolean, reflect: true},
        _deleteButtonClass: {type: Boolean, attribute: false},
    };
  
    constructor() {
        super();
        this.id = -1;
        this.task = "";
        this.done = false;
        this._deleteButtonClass = "hide";
    }
  
    connectedCallback() {
        super.connectedCallback()
        this.addEventListener('mouseenter', this._handleMouseenter);
        this.addEventListener('mouseleave', this._handleMouseleave);
    }
  
    render() {
        if(this.task){
            let icon = "vaadin:thin-square";
            let iconClass = "outstanding-icon";
            let textClass = "outstanding-text";
            if(this.done){
                icon = "vaadin:check-square-o";
                iconClass = "done-icon";
                textClass = "done-text";
            }
            return html`<span class="item">
                <span><vaadin-icon icon="${icon}" class="${iconClass}" @click=${this._toggleSelect}></vaadin-icon> 
                <span class="${textClass}">${this.task}</span></span>
                ${this._renderDeleteButton()}
            </span>`;
        }
    }
    
    _renderDeleteButton(){
        return html`<vaadin-icon icon="vaadin:close-small" class="${this._deleteButtonClass}" @click=${this._delete}></vaadin-icon>`;
    }
    
    _handleMouseenter(){
       this._deleteButtonClass = "delete-icon";
    }
    
    _handleMouseleave(){
       this._deleteButtonClass = "hide";
    }
    
    _toggleSelect(event){
        event = new CustomEvent('select', {detail: this.id, bubbles: true, composed: true});
        this.dispatchEvent(event);
    }
    
    _delete(event){
        event = new CustomEvent('delete', {detail: this.id, bubbles: true, composed: true});
        this.dispatchEvent(event);
    }
    
}
customElements.define('todos-task', TodosTask);