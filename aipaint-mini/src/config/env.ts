interface EnvironmentConfig {
  host: string;
}

const baseApi: { [key: string]: EnvironmentConfig } = {
  development: {
    host: "http://192.168.31.34:8080",
  },
  trial: {
    host: "https://yourdomian.com",
  },
  release: {
    host: "https://yourdomian.com",
  },
  production: {
    host: "https://yourdomian.com",
  },
};

const mode =  "development";

export const baseUrl = baseApi[mode].host;
