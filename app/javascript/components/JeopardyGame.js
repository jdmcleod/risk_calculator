import React from 'react'
import PropTypes from 'prop-types'
import { confirmAlert } from 'react-confirm-alert'; // Import
import 'react-confirm-alert/src/react-confirm-alert.css'; // Import css

export default class JeopardyGame extends React.Component {
  static propTypes = {
    id: PropTypes.number.isRequired
  }

  constructor(props) {
    super(props)

    this.state = {
      id: this.props.id,
      categories: this.props.categories,
      categoryName: '',
      categoryId: '',
      showPanelForm: false,
      showQuestion: false,
      showAnswer: false,
      panelAmmount: '',
      panelQuestion: '',
      panelAnswer: '',
      selectedPanel: '',
      editPanel: false
    }
  }

  componentDidMount() {
    const pusher = new Pusher('12e21f086ab8bbad38d2', {
      cluster: 'us2',
      forceTLS: true
    })

    const channel = pusher.subscribe('jeopardy');
    channel.bind('update', (data) => {
      this._fetchGameData()
    })
  }

  _fetchGameData() {
    fetch(`/jeopardy_games/${this.props.id}.json`, {
      headers: { 'Content-Type': 'application/json' },
      method: 'GET',
    }).then(response => response.json()).then(categories => {
      this.setState((prevState) => {
        return {
          categories: categories,
          showPanelForm: false
        }
      })
    })
  }

  addCategory() {
    fetch(`/jeopardy_games/${this.props.id}/add_category.json`, {
      headers: { 'Content-Type': 'application/json' },
      method: 'POST',
      body: JSON.stringify({
       name: this.state.categoryName
      })
    })
  }

  removeCategory(categoryId) {
    confirmAlert({
      title: 'Delete',
      message: 'Are you sure delete this category?',
      buttons: [
        {
          label: 'Yes, delete it',
          onClick: () => {
            fetch(`/jeopardy_games/${this.props.id}/remove_category.json`, {
              headers: { 'Content-Type': 'application/json' },
              method: 'POST',
              body: JSON.stringify({
              category_id: categoryId
              })
            })
          }
        },
        {
          label: 'No',
        }
      ]
    });
  }

  addPanel() {
    fetch(`/jeopardy_games/${this.props.id}/add_panel.json`, {
      headers: { 'Content-Type': 'application/json' },
      method: 'POST',
      body: JSON.stringify({
        category_id: this.state.categoryId,
        ammount: this.state.panelAmmount,
        question: this.state.panelQuestion,
        answer: this.state.panelAnswer
      })
    })

    this.setState({ panelAmmount: '', panelQuestion: '', panelAnswer: '', categoryId: '', editPanel: false })
  }

  editPanel() {
    fetch(`/jeopardy_games/${this.props.id}/edit_panel.json`, {
      headers: { 'Content-Type': 'application/json' },
      method: 'PATCH',
      body: JSON.stringify({
        category_id: this.state.categoryId,
        panel_id: this.state.selectedPanel.id,
        ammount: this.state.panelAmmount,
        question: this.state.panelQuestion,
        answer: this.state.panelAnswer
      })
    })

    this.setState({ panelAmmount: '', panelQuestion: '', panelAnswer: '', categoryId: '', editPanel: false })
  }

  removePanel() {
    fetch(`/jeopardy_games/${this.props.id}/remove_panel.json`, {
      headers: { 'Content-Type': 'application/json' },
      method: 'POST',
      body: JSON.stringify({
        category_id: this.state.selectedPanel.category_id,
        panel_id: this.state.selectedPanel.id
      })
    })
  }

  showPanelForm(categoryId, edit) {
    this.setState({ showPanelForm: true, showQuestion: false, categoryId: categoryId, editPanel: edit })
  }

  showQuestion(panel) {
    this.setState({ showQuestion: true, selectedPanel: panel })
  }

  showAnswer(panel) {
    this.setState({ showAnswer: true, selectedPanel: panel })
  }

  hideQuestion() {
    this.setState({ showQuestion: false, showAnswer: false })
  }

  renderPanelForm() {
    if (this.state.showPanelForm) {
      return (
        <div className='panel-form-container'>
          <div className='panel-form-inner'>
            <h5 className='mt-2'>Ammount</h5>
            <input defaultValue={this.state.selectedPanel.ammount} className='form-control panel-ammount' type='text' onChange={this.panelAmmountHandler.bind(this)} />
            <h5 className='mt-2'>Question</h5>
            <textarea defaultValue={this.state.selectedPanel.question} rows="5" className='form-control panel-question' type='text' onChange={this.panelQuestionHandler.bind(this)} />
            <h5 className='mt-2'>Answer</h5>
            <textarea defaultValue={this.state.selectedPanel.answer} rows="3" className='form-control panel-answer' type='text' onChange={this.panelAnswerHandler.bind(this)} />
            <div className='justify-center'>
              {this.renderSaveButton()}
              <button className='btn btn-outline-primary mt-3 ml-3' onClick={() => this.removePanel()}>delete</button>
            </div>
          </div>
        </div>
      )
    }
  }

  renderSaveButton() {
    if (this.state.editPanel) {
      return <button className='btn btn-outline-primary mt-3' onClick={() => this.editPanel()}>save</button>
    } else {
      return <button className='btn btn-outline-primary mt-3' onClick={() => this.addPanel()}>save</button>
    }
  }

  renderCategories() {
    return this.state.categories.map(category => {
      return (
        <div key={category.name} className='card category'>
          <h5 className='text-align-center mt-2'>{category.name}</h5>
          {this.renderPanels(category)}
          <button className='btn btn-outline-secondary m-1' onClick={() => this.showPanelForm(category.id, false)}>add question</button>
          <button className='btn btn-outline-danger m-1' onClick={() => this.removeCategory(category.id)}>remove</button>
        </div>
      )
    })
  }

  renderQuestion() {
    if (this.state.showQuestion) {
      return (
        <div className='panel-form-container'>
          <div className='panel-form-inner'>
            <div className='justify-center'>
              <div className="panel-ammount-open">{this.state.selectedPanel.ammount}</div>
              <button className='btn btn-outline-primary m-1 close-panel' onClick={() => this.hideQuestion()}>Close</button>
              <button className='btn btn-outline-primary m-1 close-panel' onClick={() => this.showPanelForm(this.state.selectedPanel.category_id, true)}>Edit</button>
            </div>
            <div className='question mt-3'>{this.state.selectedPanel.question}</div>
            <button className='btn btn-outline-primary mt-5' onClick={() => this.showAnswer(this.state.selectedPanel)}>View Answer</button>
            {this.renderAnswer()}
          </div>
        </div>
      )
    }
  }

  renderAnswer() {
    if (this.state.showAnswer) {
      return (
        <div className='answer mt-3'>
          {this.state.selectedPanel.answer}
        </div>
      )
    }
  }

  renderPanels(category) {
    if (category.panels.length > 0) {
      return category.panels.sort((a, b) => a.ammount - b.ammount).map(panel => {
        return (
          <div key={panel.id} className='card question-panel' onClick={() => this.showQuestion(panel)}>
            <h5 className='text-align-center mt-1 panel-ammount'>{panel.ammount}</h5>
          </div>
        )
      })
    }
  }

  categoryNameInputHandler(event) {
    this.setState({ categoryName: event.target.value });
  }

  panelAmmountHandler(event) {
    this.setState({ panelAmmount: event.target.value });
  }

  panelQuestionHandler(event) {
    this.setState({ panelQuestion: event.target.value });
  }

  panelAnswerHandler(event) {
    this.setState({ panelAnswer: event.target.value });
  }

  render() {
    return (
      <div className='flex justify-center p-2'>
        {this.renderPanelForm()}
        {this.renderCategories()}
        {this.renderQuestion()}
        <div className='flex-column'>
          <input className='form-control' placeholder='name' type='text' onChange={this.categoryNameInputHandler.bind(this)}/>
          <button className='btn btn-outline-info mt-2' onClick={() => this.addCategory()}>add category</button>
        </div>
      </div>
    )
  }
}
