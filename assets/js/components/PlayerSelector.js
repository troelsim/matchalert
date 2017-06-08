import React from 'react';
import Select from 'react-select';
// import fetch from 'whatwg-fetch';

class PlayerSelector extends React.Component {
  loadOptions() {
    fetch('http://' + document.location.host + '/players')
    .then(res => {
      res.json().then(data => {
        const players = data.players.map(player => ({value: player, label: player}));
        this.setState({options: players});
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
    this.loadOptions();
  }


  render(){
    return <Select
      multi={true}
      value={this.state.value}
      options={this.state.options}
      name="tossi"
      onChange={(value) => this.setState({value})}
    />;
  }
}

export default PlayerSelector;