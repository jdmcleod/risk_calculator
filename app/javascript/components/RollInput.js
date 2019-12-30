import React from 'react'
import PropTypes from 'prop-types'

export default class RollInput extends React.Component {
  static propTypes = {
    players: PropTypes.array.isRequired,
    id: PropTypes.number.isRequired
  }

  constructor(props) {
    super(props)

    this.state = {
      players: this.props.players,
      id: this.props.id,
      message: 'Select the attacker',
      attacker: '',
      defender: '',
      winner: '',
      diceRatio: '',
      selectPointer: 'attacker'
    }
  }

  // Handlers

  handleRoll(value) {
    fetch(`/calculators/${this.state.id}/roll.json`, {
      headers: { 'Content-Type': 'application/json' },
      method: 'POST',
      body: JSON.stringify({ attacker: this.state.attacker, defender: this.state.defender,
        winner: this.state.winner, dice_ratio: this.state.diceRatio,
        number_wins: value })
      })
    window.location.reload(false)
  }

  handleButton(value) {
    if (this.state.selectPointer === 'attacker') {
      this._selectAttacker(value)
    }
    else if (this.state.selectPointer === 'defender') {
      this._selectDefender(value)
    }
    else if (this.state.selectPointer === 'winner') {
      this._selectWinner(value)
    }
    else if (this.state.selectPointer === 'diceRatio') {
      this._selectDiceRatio(value)
    }
    else if (this.state.selectPointer === 'number'){
      this.handleRoll(value)
    }
  }

  _selectAttacker(value) {
    this.setState((prevState) => {
      return {
        message: 'Select the defender',
        attacker: value,
        winner: '',
        players: this.state.players.filter(player => player !== value),
        selectPointer: 'defender'
      }
    })
  }

  _selectDefender(value) {
    this.setState((prevState) => {
      return {
        message: 'Who won?',
        defender: value,
        winner: '',
        players: [this.state.attacker, value, 'tie'],
        selectPointer: 'winner'
      }
    })
  }

  _selectWinner(value) {
    this.setState((prevState) => {
      return {
        message: 'How many dice were rolled? (W-L)',
        winner: value,
        players: ['1-1', '1-2', '2-1', '3-1', '2-2', '3-2'],
        selectPointer: 'diceRatio'
      }
    })
  }

  _selectDiceRatio(value) {
    this.setState((prevState) => {
      return {
        message: 'How many pieces did the winner take?',
        diceRatio: value,
        players: ['1', '2'],
        selectPointer: 'number'
      }
    })
  }

  _renderPlayers() {
    return this.state.players.map(player => {
      return (
        <button key={player} className='btn btn-outline-success m-2' value={player}
                onClick={() => this.handleButton(player)}>{player}</button>
      )
    })
  }

  _handleSelectAttacker() {
    this.setState((prevState) => {
      return {
        message: 'Select the attacker',
        players: this.props.players,
        selectPointer: 'attacker'
      }
    })
  }

  _handleSelectDefender() {
    this.setState((prevState) => {
      return {
        message: 'Select the defender',
        players: this.props.players.filter(player => player !== this.state.attacker),
        selectPointer: 'defender'
      }
    })
  }

  _handleSelectWinner() {
    this.setState((prevState) => {
      return {
        message: 'Who won?',
        players: [this.state.attacker, this.state.defender],
        selectPointer: 'winner'
      }
    })
  }

  _handleSelectDiceRatio() {
    this.setState((prevState) => {
      return {
        message: 'How many dice were rolled? (W-L)',
        players: ['1-1', '1-2', '2-1', '3-1', '2-2', '3-2'],
        selectPointer: 'diceRatio'
      }
    })
  }

  render() {
    return (
      <div className='contents'>
        <div className='roll-status-container'>
          <div className='flex flex-column'>
            <p className='roll-status-label'>Attacker</p>
            <button id='attacker' className='roll-status' onClick={() => this._handleSelectAttacker()}>{this.state.attacker}</button>
          </div>
          <div className='flex flex-column'>
            <p className='roll-status-label'>Defender</p>
            <button id='defender' className='roll-status' onClick={() => this._handleSelectDefender()}>{this.state.defender}</button>
          </div>
          <div className='flex flex-column'>
            <p className='roll-status-label'>Winner</p>
            <button id='winner' className='roll-status' onClick={() => this._handleSelectWinner()}>{this.state.winner}</button>
          </div>
          <div className='flex flex-column'>
            <p className='roll-status-label'>#Dice</p>
            <button id='winner' className='roll-status' onClick={() => this._handleSelectDiceRatio()}>{this.state.diceRatio}</button>
          </div>
        </div>

        <p className='mt-1 mb-0'>{this.state.message}</p>

        { this._renderPlayers() }
      </div>
    )
  }
}

