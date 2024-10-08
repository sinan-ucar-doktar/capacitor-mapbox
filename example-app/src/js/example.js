import { CapacitorMapbox } from 'capacitor-mapbox';

window.testEcho = () => {
    const inputValue = document.getElementById("echoInput").value;
    CapacitorMapbox.echo({ value: inputValue })
}
