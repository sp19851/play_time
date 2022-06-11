
const App = {
    
    data() {
        return {
            show: false, 
            notifshow:false,
            modalWindowShoing: false,
            fullData: [                {"citizenid":"SQZ50819","job":"police","id":1,"isboss":true,"name":"Jonhson Jonhson","timeingame":19,"gang":"vagos","lastenter":1654835411000},{"citizenid":"CRUSO001","job":"ambulance","id":2,"isboss":false,"name":"Smith Smith","timeingame":22,"gang":"none","lastenter":1654835051000}
            ],
            fractions: [],
            gangs: [],
            selecdata: [
                {id: "1", label: "LSPD", name: "LSPD"},
                {id: "2", label: "Ambulance", name: "ambulance"},
                {id: "3", label: "Mechanic", name: "mechanic"},
            ],
            currentFraction: "",
            fractionsShow:false,
            gangs: [
                {id: "1", label: "Ballas", name: "ballas"},
                {id: "2", label: "Vagos", name: "vagos"},
               
            ],
            currentGang: "",
            gangsShow:false,
            players: [
                {"citizenid":"SQZ50819","job":"police","id":1,"isboss":true,"name":"Jonhson Jonhson","timeingame":19,"gang":"vagos","lastenter":1654835411000},{"citizenid":"CRUSO001","job":"ambulance","id":2,"isboss":false,"name":"Smith Smith","timeingame":22,"gang":"none","lastenter":1654835051000}
            ],
            callSingFiltered: false,
            myCallsign: "",
            myType: "",
           
        }
    
    },    
    
    components:{},
  

    methods: {
       
        showingForm(bool) {
           this.show = bool;
          
        },

       
        onClose() {
            this.show = false;
            $.post('https://play_time/close');

        },

        onNotif() {
            this.notifshow = true;
        },
        offNotif() {
            console.log('offNotif')
            this.notifshow = false;
        },
        
        selected() {
            //console.log('*****', this.currentFraction.label)
            let array = []
            for (let i = 0; i < this.players.length; i += 1) {
                let player = this.players[i]
                //console.log('call[j].callsing', call.callsing, this.myCallsign)
                if (player.job === this.currentFraction.name || player.gang === this.currentFraction.name){
                    array.push(player);
                }
            }
            this.players = array
            this.modalWindowShoing = false
        },

        IsBoss(item) {
            //
            if(item.isboss) {
                return true;
            } else {
                return false;
            }
 
        },

        allPlayers() {
            this.players = this.fullData
 
        },

        onFractions() {
            this.selecdata = this.fractions
            this.modalWindowShoing = true
        },
        onGangs() {
            this.selecdata = this.gangs
            this.modalWindowShoing = true
        },
        
        onBosses() {
            let array = []
            for (let i = 0; i < this.players.length; i += 1) {
                let player = this.players[i]
                //console.log('call[j].callsing', call.callsing, this.myCallsign)
                if (player.isboss){
                    array.push(player);
                }
            }
            this.players = array
        },

      
      
},
    
    mounted() {
        this.listener = window.addEventListener("message", (event) => {
            //console.log('test window.addEventListener', event.data.action)
            if(event.data.action === 'open') {
                //console.log(JSON.stringify(event.data))
                this.fullData = event.data.players  
                this.players = event.data.players 
                this.fractions = event.data.fractions
                this.gangs = event.data.gangs
                this.show = true
                this.modalWindowShoing = false
                //this.alerts = event.data.alerts;
                /*for (let i = 0; i < event.data.alerts.length; i += 1) {
                    let Item = event.data.alerts[i]
                    //console.log(i, Item.description, Item.attached)
                    for (let j = 0; j < Item.attached.length; j += 1) {
                        let Item2 = Item.attached[j]
                        console.log(j, Item2, Item2.cs, Item2.id_at)
                        console.log(JSON.stringify(Item2))
                        for (let y = 0; y < Item2.length; y += 1) {
                            console.log(y, Item2[y])
                        }
                        
                    }
                }*/
                //this.myCallsign = event.data.myCallsign;
                //this.myType = event.data.type;
                //this.filteredTypes();
                //console.log('myCallsign', this.myCallsign)
                //this.showingForm(true);

            } else if(event.data.action === 'close') {
                this.onClose()
            } else if(event.data.action === 'onNotif') {
                this.onNotif()
            } else if(event.data.action === 'offNotif') {
                this.offNotif()
            } else if(event.data.action === 'refresh') {
              

            }
            
        });
        window.document.onkeydown = event => event && event.code === 'Escape' ? this.onClose() : null
       

        
       

      },
    create: {
        

    },
    watch: {
       
    },

    computed: {
        filteredTypes() {
            console.log('filteredTypes start', this.alerts.length)
            let array = []
            for (let i = 0; i < this.alerts.length; i += 1) {
                    console.log('type', this.alerts[i].type)
                if (this.alerts[i].type === this.myType || this.alerts[i].type === "all")  {
                    //console.log('Bingo')
                    array.push(this.alerts[i]);
                }
                
                
              }
            return array
            //this.alerts = array          
            /*return this.alerts.filter((alert)=> {
                
                alert.attached.filter((calls) =>{
                  console.log(this.myCallsing, 'calls', calls)   
                  return calls.callsing.includes(this.myCallsing);
                });
               
            })*/
             
        },

        filteredAlerts() {
            let array = []
            for (let i = 0; i < this.alerts.length; i += 1) {
                //console.log('attached', this.alerts[i].attached)
                //console.log('*',JSON.stringify(this.alerts[i].attached))
                if(this.alerts[i].attached.length && this.alerts[i].attached.length>0) {
                    for (let j = 0; j < this.alerts[i].attached.length; j += 1) {
                        //console.log('+',this.alerts[i].attached[j].cs, this.myCallsing)
                        if (this.alerts[i].attached[j].cs === this.myCallsign && (this.alerts[i].type === this.myType || this.alerts[i].type === "all"))  {
                            //console.log('Bingo')
                            array.push(this.alerts[i]);
                        }
                    }
                }
              }
            return array
                        
            /*return this.alerts.filter((alert)=> {
                
                alert.attached.filter((calls) =>{
                  console.log(this.myCallsing, 'calls', calls)   
                  return calls.callsing.includes(this.myCallsing);
                });
               
            })*/
             
        },
    }
}




let app = Vue.createApp(App)
app.mount('#app')

//v-if="item.attached.lenght>0"