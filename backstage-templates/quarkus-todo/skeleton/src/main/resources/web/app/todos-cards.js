import {LitElement, html, css} from 'lit';
import '@vaadin/icon';
import '@vaadin/vaadin-lumo-styles/vaadin-iconset.js';
import '@vaadin/icons';
import './todos-task.js';
import { Notification } from '@vaadin/notification';

class TodosCards extends LitElement {
    static styles = css`
        :host {
            display: flex;
            justify-content: center;
        }
        .inputBar {
            display: flex;
            align-items: center;
            font-size: 24px;
        }
        .input {
            padding: 12px 20px;
            margin: 8px 0;
            border: 0px solid white;
            font-size: 24px;
            color: var(--lumo-body-text-color);
            outline: none;
            background: var(--lumo-contrast-10pct);
            width: 450px;
        }
        input::placeholder {
            font-style: italic;
            color: var(--lumo-contrast-70pct);
        }
    
        .cards {
            display: flex;
            flex-direction: column;
            border: 1px solid var(--lumo-contrast-20pct);
            -webkit-box-shadow: 5px 5px 15px 5px var(--lumo-contrast-10pct); 
            box-shadow: 5px 5px 15px 5px var(--lumo-contrast-10pct);
            min-width: 550px;
        }
        .items {
            display: flex;
            flex-direction: column;
            gap: 5px;
            padding-top: 10px;
            padding-bottom: 10px;
            overflow-y: scroll;
            overflow-x: hidden;
            max-height: 600px;
        }
        
        hr {
            border-bottom: none;
            width: 100%;
        }
        
        .select-all-icon {
            color: var(--lumo-contrast-70pct);
            cursor: pointer;
            padding-left: 5px;
            padding-right: 5px;
        }
    
        .cards-footer {
            display: flex;
            justify-content: space-around;
            padding-bottom: 15px;
            font-size: 14px;
            text-align: center;
            color: var(--lumo-contrast-50pct);
        }
        
        .filter {
            padding: 3px;
        }
        .selected-filter {
            background: var(--lumo-contrast-10pct);
            padding: 3px;
        }
        
        .filter:hover {
            background: var(--lumo-contrast-10pct);
            cursor: pointer;
        }
        .clear-completed:hover {
            background: var(--lumo-contrast-10pct);
            cursor: pointer;
        }
        .hide {
            visibility:hidden;
        }
    `;
    
    static properties = {
        _tasks: {type: Array, state: true},
        _filteredTasks: {type: Array, state: true},
        _filter: {type: String, state: true}
    };
    
    constructor() {
        super();
        this._tasks = [];
        this._filteredTasks = [];
        this._filter = "all";
    }
    
    render() {
        return html`<div class="cards">
            ${this._renderInput()}
            ${this._renderItems()}
            ${this._renderFooter()}
        </div>`;
    }
  
    connectedCallback() {
        super.connectedCallback()
        this._fetchAllTasks();
    }
    
    _fetchAllTasks(){
        fetch("/api")
            .then(response => response.json())
            .then(response => this._setAll(response));
    }
    
    _setAll(tasks){
        this._tasks = tasks;
        this._filterTasks();
    }
    
    _filterTasks(){
        if(this._filter === "active"){
            this._filteredTasks = this._tasks.filter(obj => obj.completed === false);
        }else if(this._filter === "completed") {
            this._filteredTasks = this._tasks.filter(obj => obj.completed === true);
        }else{
            this._filteredTasks = this._tasks;
        }
    }
    
    _renderInput(){
        return html`<div class="inputBar">
                        <vaadin-icon icon="vaadin:chevron-down" class="select-all-icon" @click=${this._selectAll}></vaadin-icon>
                        <input class="input" type="text" placeholder="What needs to be done ?" @keypress="${this._handleRequest}"></input>
                    </div>`;
        
    }
    
    _renderItems(){
        if(this._filteredTasks){
            return html`<div class="items">
                        ${this._filteredTasks.map((task) =>
                            this._renderItem(task)        
                        )}
                    </div>`;
        }
    }
    
    _renderItem(task){
        return html`<todos-task id=${task.id} task="${task.title}" ?done=${task.completed} @select=${this._toggleSelect} @delete=${this._deleteItem}></todos-task><hr/>`;
    }
    
    _renderFooter(){
        let outstandingTasksCount = this._tasks.filter(obj => obj.completed === false).length;
        let someCompleted = this._tasks.some(obj => obj.completed === true);
        
        let clearCompletedClass = "clear-completed";
        if(!someCompleted){
            clearCompletedClass = "hide";
        }
        
        return html`<div class="cards-footer">
                <span>${outstandingTasksCount} items outstanding</span>
                <div class="filters">
                    <span @click="${this._filterAll}" class="${this._getFilterClass("all")}">All</span>
                    <span @click="${this._filterActive}" class="${this._getFilterClass("active")}">Active</span>
                    <span @click="${this._filterCompleted}" class="${this._getFilterClass("completed")}">Completed</span>
                </div>
                <span @click="${this._clearCompleted}" class="${clearCompletedClass}">Clear completed</span>
            </div>`;
    }
    
    _getFilterClass(forFilter){
        if(this._filter === forFilter){
            return "filter selected-filter";
        }
        return "filter";
    }
    
    _selectAll(event){
        let allCompleted = this._tasks.every(obj => obj.completed === true);
        if(allCompleted){
            this._markAll(false);
        }else{
            this._markAll(true);
        }
    }
    
    _markAll(completed){
        for (const task of this._tasks) {
            task.completed = completed;
            this._updateTask(task);
        }
    }
    
    _handleRequest(event) {
        if (event.keyCode == 13) {
            event.preventDefault();
            let task = {title:event.target.value, completed: false};
            
            const request = new Request('/api', {
                                            method: 'POST',
                                            body: JSON.stringify(task),
                                            headers: {
                                                'Content-Type': 'application/json'
                                            }
                                        });
            fetch(request)
                        .then(r =>  r.json().then(data => ({status: r.status, body: data})))
                        .then(obj => this._handleResponse(obj));
            event.target.value = "";
        }
    }
    
    _handleResponse(statusAndBody) {
        if(statusAndBody.status === 201){
            this._addToTasks(statusAndBody.body);
        }else {
            this._showErrorMessage(statusAndBody.body.details);
        }
    }
    
    _toggleSelect(e){
        let task = this._getTaskById(e.detail);
        task.completed = !task.completed;
        this._updateTask(task);
    }
    
    _updateTask(task){
        const request = new Request('/api/' + task.id, {
                                            method: 'PATCH',
                                            body: JSON.stringify(task),
                                            headers: {
                                                'Content-Type': 'application/json'
                                            }
                                        });
        fetch(request)
                        .then(r =>  r.json().then(data => ({status: r.status, body: data})))
                        .then(obj => this._updateTaskInTasks(obj));
    }
    
    _deleteItem(e) {
        const request = new Request('/api/' + e.detail, {
                                            method: 'DELETE',
                                            headers: {
                                                'Content-Type': 'application/json'
                                            }
                                        });
        fetch(request)
                    .then(r => this._fetchAllTasks());
        
    }
    
    _handleDeleteResponse(status) {
        if(status === 204){
            this._fetchAllTasks();
        }else {
            this._showErrorMessage("Delete failed with HTTP Response " + status);
        }
    }
    
    _filterAll(event){
        this._filter = "all";
        this._filterTasks();
    }
    
    _filterActive(event){
        this._filter = "active";
        this._filterTasks();
    }
    
    _filterCompleted(event){
        this._filter = "completed";
        this._filterTasks();
    }
    
    _clearCompleted(event){
        const request = new Request('/api', {
                                            method: 'DELETE',
                                            headers: {
                                                'Content-Type': 'application/json'
                                            }
                                        });
        fetch(request)
                    .then(r => this._fetchAllTasks());
    }
    
    _updateTaskInTasks(task) {
        this._tasks.map(obj => {
            if (obj.id === task.id) {
                return { ...obj, ...task };
            }
            return obj;
        });
        this._tasks = [
            ...this._tasks];
        
        this._filterTasks();
        
    }
    
    _getTaskById(id){
        return this._tasks.find(obj => obj.id === id);
    }
    
    _addToTasks(task){
        this._tasks = [
            task,
            ...this._tasks
        ];
        this._filterTasks();
    }
    
    _showErrorMessage(message){
        const notification = Notification.show(message, {
                                    position: 'bottom-stretch',
                                    duration: 10000,
                                });
    }
}
customElements.define('todos-cards', TodosCards);