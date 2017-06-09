import React from 'react';
import Select from 'react-select';
import 'whatwg-fetch';

class PlayerSelector extends React.Component {
  loadOptions() {
    return fetch('http://' + document.location.host + '/players')
    .then(res => {
      return res.json().then(data => {
        const players = data.players.map(player => ({value: player.id, label: player.name}));
        this.setState({options: players});
      });
    });
  }

  loadPlayers() {
    return fetch(document.location.href.replace(/\/$/, "") + '/players')
    .then(res => {
      return res.json().then(data => {
        const players = data.players.map(player => ({value: player.id, label: player.name}));
        this.setState({value: players});
      });
    });
  }

  constructor(props){
    super(props);
    this.state = {
      value: [],
      options: []
    }
  }

  componentWillMount() {
    this.loadOptions().then(() => {
      if (document.location.pathname != "/"){
        this.loadPlayers();
      }
    });
  }


  render(){
    return <Select
      multi={true}
      value={this.state.value}
      options={this.state.options}
      name="subscription[players][]"
      placeholder="Favourite players ..."
      onChange={(value) => this.setState({value})}
    />;
  }
}

export default PlayerSelector;
