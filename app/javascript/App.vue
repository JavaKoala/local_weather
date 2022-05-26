<template>
  <div id="app">
    <div class="search-container">
      <div class="jumbotron">
        <h1>Welcome to the temperature forecast</h1>
        <h4>Please enter your city and state</h4>
      </div>

      <ValidationObserver v-slot="{ invalid }">
        <form @submit.prevent="getForecast" class="forecast-form">
          <div class="form-group">
            <ValidationProvider name="City" rules="required" v-slot="{ errors }">
              <label for="city" class="city-state-input">City</label>
              <input id="city-input" v-model="city" type="text">
              <span class="error-label">{{ errors[0] }}</span>
            </ValidationProvider>
          </div>

          <div class="form-group">
            <ValidationProvider name="State" rules="required" v-slot="{ errors }">
              <label for="state" class="city-state-input">State</label>
              <select id="state-input" v-model="state">
                <option disabled value="">Please select a state</option>
                <option v-for="stateOption in stateOptions" :key="stateOption.abbreviation">
                  {{stateOption.name}}
                </option>
              </select>
              <span class="error-label">{{ errors[0] }}</span>
            </ValidationProvider>
          </div>

          <button type="submit" class="btn btn-primary btn-lg" :disabled="invalid">Get forecast</button>
        </form>
      </ValidationObserver>

      <p>Cache hit: {{ cacheHit }}</p>
      <p v-if="foundCity === false">
        Found city: false
      </p>

    </div>

    <div v-if="loading === false" class="forcast-container">
      <h3>
        Forecast:
      </h3>

      <div>
        <b-table striped hover :items="forecast" :fields="forecastFields"></b-table>
      </div>
    </div>
    <div v-else class="loader">
    </div>
  </div>
</template>

<script>
import { BTable } from 'bootstrap-vue';
import { ValidationObserver, ValidationProvider } from 'vee-validate';
import { extend } from 'vee-validate';
import { required } from 'vee-validate/dist/rules';
import { statesHelper } from './helpers/location-helper';

extend('required', required);

export default {
  data() {
    return {
      cacheHit: '',
      city: '',
      forecastFields: [ 'name', 'temperature', 'temperatureUnit', 'detailedForecast' ],
      forecast: [],
      foundCity: true,
      loading: false,
      state: '',
      stateOptions: statesHelper(),
    }
  },
  methods: {
    async getForecast() {
      this.loading = true;
      this.forecast = [];
      this.cacheHit = '';

      const params = new URLSearchParams();
      params.append('city', this.city);
      params.append('state', this.state);

      const forecast = await fetch(`/forecast?${params.toString()}`);
      const forecastJson = await forecast.json();

      this.cacheHit = forecastJson.cache_hit;
      if (Array.isArray(forecastJson.forecast)) {
        this.forecast = forecastJson.forecast;
        this.foundCity = true;
      } else {
        this.foundCity = false;
      }

      this.loading = false;
    }
  },
  components: {
    BTable,
    ValidationObserver,
    ValidationProvider
  }
}
</script>

<style scoped>
  .search-container {
    margin: auto;
    width: 75%;
  }

  .forecast-form {
    margin-bottom: 15px;
  }

  .city-state-input {
    width: 40px;
  }

  .error-label {
    color: #FF0000;
  }
  .loader {
    margin: auto;
    border: 7px solid #f3f3f3;
    border-top: 7px solid #708090;
    border-radius: 50%;
    width: 60px;
    height: 60px;
    animation: spin 2s linear infinite;
  }

  @keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
  }

  .forcast-container {
    margin: auto;
    width: 90%;
  }
</style>

