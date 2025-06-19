const request = require("supertest");
const app = require("../src/index");

describe("GET /", () => {
  it("should return 200 OK", async () => {
    const response = await request(app).get("/");
    expect(response.status).toBe(200);
    expect(response.text).toBe("Hello, Node.js app is running!");
  });
});
