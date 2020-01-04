import React from 'react'
import PropTypes from 'prop-types'
import { confirmAlert } from 'react-confirm-alert';
import Teams from './Teams'

export default class JeopardyGame extends React.Component {
  static propTypes = {
    id: PropTypes.number.isRequired
  }

  constructor(props) {
    super(props)

    this.state = {
      id: this.props.id,
      isOwner: this.props.isOwner,
      isPublic: this.props.isPublic,
      gameName: this.props.gameName,
      categories: this.props.categories,
      teams: this.props.teams,
      categoryName: '',
      categoryId: '',
      showPanelForm: false,
      showQuestion: false,
      showAnswer: false,
      panelAmmount: '',
      panelQuestion: '',
      panelAnswer: '',
      selectedPanel: '',
      editPanel: false,
      editMode: false
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
    }).then(response => response.json()).then(data => {
      this.setState((prevState) => {
        return {
          categories: data.categories,
          teams: data.teams,
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

  addTeam() {
    fetch(`/jeopardy_games/${this.props.id}/add_team.json`, {
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

  removeTeam(id) {
    confirmAlert({
      title: 'Delete',
      message: 'Are you sure delete this team?',
      buttons: [
        {
          label: 'Yes, delete it',
          onClick: () => {
            fetch(`/jeopardy_games/${this.props.id}/remove_team.json`, {
              headers: { 'Content-Type': 'application/json' },
              method: 'POST',
              body: JSON.stringify({
                team_id: id
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

  resetPanels() {
    confirmAlert({
      title: 'Reset',
      message: 'The panels will all be marked as uncompleted',
      buttons: [
        {
          label: 'Yes',
          onClick: () => {
            fetch(`/jeopardy_games/${this.props.id}/reset_panels.json`, {
              headers: { 'Content-Type': 'application/json' },
              method: 'POST',
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

  handleScore(teamId, sign, ammountOverride) {
    let ammount = this.state.selectedPanel.ammount
    if (ammountOverride) ammount = ammountOverride
    if (sign === 'negative') ammount = (ammount * -1)
    fetch(`/jeopardy_games/${this.props.id}/add_score.json`, {
      headers: { 'Content-Type': 'application/json' },
      method: 'POST',
      body: JSON.stringify({
        team_id: teamId,
        category_id: this.state.selectedPanel.category_id,
        panel_id: this.state.selectedPanel.id,
        ammount: ammount
      })
    })

    this.setState({ showQuestion: false, showAnswer: false })
  }

  handleNoAnswer() {
    fetch(`/jeopardy_games/${this.props.id}/no_answer.json`, {
      headers: { 'Content-Type': 'application/json' },
      method: 'POST',
      body: JSON.stringify({
        category_id: this.state.selectedPanel.category_id,
        panel_id: this.state.selectedPanel.id
      })
    })

    this.setState({ showQuestion: false, showAnswer: false })
  }

  toggleScope() {
    fetch(`/jeopardy_games/${this.props.id}/toggle_scope.json`, {
      headers: { 'Content-Type': 'application/json' },
      method: 'POST',
    })

    if (this.state.isPublic) this.setState({ isPublic: false })
    if (!this.state.isPublic) this.setState({ isPublic: true })
  }

  saveGame() {
    fetch(`/jeopardy_games/${this.props.id}/save_game.json`, {
      headers: { 'Content-Type': 'application/json' },
      method: 'POST',
    })

    window.location = '/jeopardy_games'
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
            <h5 className='mt-2 yellow'>Ammount</h5>
            <input defaultValue={this.state.selectedPanel.ammount} className='form-control panel-ammount' type='text' onChange={this.panelAmmountHandler.bind(this)} />
            <h5 className='mt-2 yellow'>Question</h5>
            <textarea defaultValue={this.state.selectedPanel.question} rows="5" className='form-control panel-question' type='text' onChange={this.panelQuestionHandler.bind(this)} />
            <h5 className='mt-2 yellow'>Answer</h5>
            <textarea defaultValue={this.state.selectedPanel.answer} rows="3" className='form-control panel-answer' type='text' onChange={this.panelAnswerHandler.bind(this)} />
            <div className='justify-center'>
              {this.renderSaveButton()}
              <button className='btn btn-outline-warning mt-3 ml-3' onClick={() => this.removePanel()}>delete</button>
            </div>
          </div>
        </div>
      )
    }
  }

  renderSaveButton() {
    if (this.state.editPanel) {
      return <button className='btn btn-outline-warning mt-3' onClick={() => this.editPanel()}>save</button>
    } else {
      return <button className='btn btn-outline-warning mt-3' onClick={() => this.addPanel()}>save</button>
    }
  }

  renderCategories() {
    return this.state.categories.map(category => {
      return (
        <div key={category.name} className='card category'>
          <h5 className='category-name'>{category.name}</h5>
          {this.renderPanels(category)}
          {this.renderPanelControls(category)}
        </div>
      )
    })
  }

  renderPanelControls(category) {
    if (this.state.editMode) {
      return (
        <div className='m-1'>
          <button className='btn btn-outline-secondary w-100' onClick={() => this.showPanelForm(category.id, false)}>+</button>
          <button className='btn btn-outline-danger mt-1 w-100' onClick={() => this.removeCategory(category.id)}>remove</button>
        </div>
      )
    }
  }

  renderQuestion() {
    if (this.state.showQuestion) {
      return (
        <div className='panel-form-container'>
          <div className='panel-form-inner'>
            <div className='justify-center'>
              <div className="panel-ammount-open">{this.state.selectedPanel.ammount}</div>
              <button className='btn btn-outline-warning m-1 close-panel' onClick={() => this.showPanelForm(this.state.selectedPanel.category_id, true)}>Edit</button>
              <button className='btn btn-outline-warning m-1 close-panel' onClick={() => this.hideQuestion()}>Close</button>
            </div>
            <div className='question mt-3'>{this.state.selectedPanel.question}</div>
            <button className='btn btn-outline-warning mt-5' onClick={() => this.showAnswer(this.state.selectedPanel)}>View Answer</button>
            {this.renderAnswer()}
          </div>
        </div>
      )
    }
  }

  renderEditButton() {
    if (this.state.isOwner) {
      return <button className='btn btn-outline-secondary show-control-panel' onClick={() => this.toggleEditMode()}>Edit</button>
    } else {
      return <button className='btn btn-outline-secondary show-control-panel' onClick={() => this.saveGame()}>Save to my games</button>
    }
  }

  renderAnswer() {
    if (this.state.showAnswer) {
      return (
        <div className='answer mt-3'>
          <div className='mb-3'>{this.state.selectedPanel.answer}</div>
          {this.renderScoreButtons()}
          <button className='btn btn-outline-secondary m-2 score-button' onClick={() => this.handleNoAnswer()}>no guesses</button>
        </div>
      )
    }
  }

  renderScoreButtons() {
    return this.state.teams.map(team => {
      return (
        <div key={team.id} className='flex'>
          <button className='btn btn-outline-success m-2 score-button' onClick={() => this.handleScore(team.id, 'positive')}>{team.name} guessed right</button>
          <button className='btn btn-outline-danger m-2 score-button' onClick={() => this.handleScore(team.id, 'negative')}>{team.name} guessed wrong</button>
        </div>
      )
    })
  }

  renderPanels(category) {
    if (category.panels.length > 0) {
      return category.panels.sort((a, b) => a.ammount - b.ammount).map(panel => {
        return (
          <div key={panel.id} className='card question-panel' onClick={() => this.showQuestion(panel)}>
            {this.renderPanel(panel)}
          </div>
        )
      })
    }
  }

  renderPanel(panel) {
    if (!panel.completed === true) {
      return <h5 className='text-align-center mt-1 panel-ammount'>{panel.ammount}</h5>
    }
  }

  renderControlPanel() {
    if (this.state.editMode) {
      return (
        <div className='flex-column'>
          <div className='control-panel'>
            <h5 className='text-align-center'>Control Panel</h5>
            <input className='form-control' placeholder='name' type='text' onChange={this.categoryNameInputHandler.bind(this)} />
            <button className='btn btn-outline-info mt-2' onClick={() => this.addCategory()}>add category</button>
            <button className='btn btn-outline-info mt-2' onClick={() => this.addTeam()}>add team</button>
            <button className='btn btn-outline-warning mt-2' onClick={() => this.resetPanels()}>reset panels</button>
            {this.renderToggleScopeButton()}
          </div>
        </div>
      )
    }
  }

  renderToggleScopeButton() {
    if (this.state.isPublic) {
      return <button className='btn btn-outline-secondary mt-2' onClick={() => this.toggleScope()}>make private</button>
    } else {
      return <button className='btn btn-outline-secondary mt-2' onClick={() => this.toggleScope()}>make public</button>
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

  toggleEditMode() {
    if (this.state.editMode === false) {
      this.setState({editMode: true})
    } else {
      this.setState({editMode: false})
    }
  }

  render() {
    return (
      <div>
        <div className='justify-center'>
          <h1 className='mt-3'>{this.state.gameName}</h1>
          {this.renderEditButton()}
        </div>
        <Teams teams={this.state.teams} removeTeam={this.removeTeam.bind(this)} editMode={this.state.editMode} handleScore={this.handleScore.bind(this)}/>
        <div className='flex justify-center p-2'>
          {this.renderPanelForm()}
          {this.renderCategories()}
          {this.renderQuestion()}
          {this.renderControlPanel()}
        </div>
      </div>
    )
  }
}
