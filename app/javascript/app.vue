<template>
  <div id="app">
    <div style="margin: auto;width: 75%;">
      <div class="jumbotron">
        <h1>Welcome to the temperature forecast</h1>
        <h4>Please enter your city and state</h4>
      </div>

      <ValidationObserver v-slot="{ invalid }">
        <form @submit.prevent="getForecast">
          <div>
            <ValidationProvider name="City" rules="required" v-slot="{ errors }">
              <label for="city">City</label>
              <input v-model="city" type="text">
              <span>{{ errors[0] }}</span>
            </ValidationProvider>
          </div>

          <div>
            <ValidationProvider name="State" rules="required" v-slot="{ errors }">
              <label for="state">State</label>
              <input v-model="state" type="text">
              <span>{{ errors[0] }}</span>
            </ValidationProvider>
          </div>

          <button type="submit" class="btn btn-primary btn-lg" :disabled="invalid">Get forecast</button>
        </form>
      </ValidationObserver>

      <p>
        Cache hit: {{ cacheHit }}
      </p>

    </div>

    <div style="margin: auto;width: 90%;">
      <h3>
        Forecast:
      </h3>

      <div>
        <b-table striped hover :items="forecast" :fields="forecastFields"></b-table>
      </div>
    </div>
  </div>
</template>

<script>
import { ValidationObserver, ValidationProvider } from 'vee-validate';
import { extend } from 'vee-validate';
import { required } from 'vee-validate/dist/rules';

extend('required', required);

export default {
  data() {
    return {
      city: '',
      state: '',
      cacheHit: false,
      forecastFields: [ 'name', 'temperature', 'temperatureUnit', 'detailedForecast' ],
      forecast: [],
    }
  },
  methods: {
    async getForecast() {
      this.forecast = [];

      const params = new URLSearchParams();
      params.append('city', this.city);
      params.append('state', this.state);

      const forecast = await fetch(`/forecast?${params.toString()}`);
      const forecastJson = await forecast.json();

      this.cacheHit = forecastJson.cache_hit;
      if (Array.isArray(forecastJson.forecast)) {
        this.forecast = forecastJson.forecast;
      }
    }
  },
  components: {
    ValidationObserver,
    ValidationProvider
  }
}
</script>

<style scoped>

</style>
