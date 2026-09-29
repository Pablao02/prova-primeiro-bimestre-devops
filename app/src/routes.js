import { Router } from "express";
import pool from "./db.js";

const router = Router();

// Health check
router.get("/health", async (req, res) => {
  try {
    await pool.query("SELECT 1");

    res.status(200).json({
      status: "ok",
      database: "connected"
    });
  } catch (error) {
    console.error("Erro no health check:", error);

    res.status(503).json({
      status: "error",
      database: "disconnected"
    });
  }
});

// CREATE
router.post("/reservas", async (req, res) => {
  try {
    const { cliente, data, status } = req.body;

    if (!cliente || !data || !status) {
      return res.status(400).json({
        error: "cliente, data e status são obrigatórios"
      });
    }

    const result = await pool.query(
      `
      INSERT INTO reservas (cliente, data, status)
      VALUES ($1, $2, $3)
      RETURNING id, cliente, data, status
      `,
      [cliente, data, status]
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error("Erro ao criar reserva:", error);

    res.status(500).json({
      error: "Erro interno ao criar reserva"
    });
  }
});

// READ - todas
router.get("/reservas", async (req, res) => {
  try {
    const result = await pool.query(
      `
      SELECT id, cliente, data, status
      FROM reservas
      ORDER BY id
      `
    );

    res.status(200).json(result.rows);
  } catch (error) {
    console.error("Erro ao listar reservas:", error);

    res.status(500).json({
      error: "Erro interno ao listar reservas"
    });
  }
});

// READ - por ID
router.get("/reservas/:id", async (req, res) => {
  try {
    const id = Number(req.params.id);

    if (!Number.isInteger(id)) {
      return res.status(400).json({
        error: "ID inválido"
      });
    }

    const result = await pool.query(
      `
      SELECT id, cliente, data, status
      FROM reservas
      WHERE id = $1
      `,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        error: "Reserva não encontrada"
      });
    }

    res.status(200).json(result.rows[0]);
  } catch (error) {
    console.error("Erro ao buscar reserva:", error);

    res.status(500).json({
      error: "Erro interno ao buscar reserva"
    });
  }
});

// UPDATE
router.put("/reservas/:id", async (req, res) => {
  try {
    const id = Number(req.params.id);
    const { cliente, data, status } = req.body;

    if (!Number.isInteger(id)) {
      return res.status(400).json({
        error: "ID inválido"
      });
    }

    if (!cliente || !data || !status) {
      return res.status(400).json({
        error: "cliente, data e status são obrigatórios"
      });
    }

    const result = await pool.query(
      `
      UPDATE reservas
      SET cliente = $1,
          data = $2,
          status = $3
      WHERE id = $4
      RETURNING id, cliente, data, status
      `,
      [cliente, data, status, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        error: "Reserva não encontrada"
      });
    }

    res.status(200).json(result.rows[0]);
  } catch (error) {
    console.error("Erro ao atualizar reserva:", error);

    res.status(500).json({
      error: "Erro interno ao atualizar reserva"
    });
  }
});

// DELETE
router.delete("/reservas/:id", async (req, res) => {
  try {
    const id = Number(req.params.id);

    if (!Number.isInteger(id)) {
      return res.status(400).json({
        error: "ID inválido"
      });
    }

    const result = await pool.query(
      `
      DELETE FROM reservas
      WHERE id = $1
      RETURNING id
      `,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        error: "Reserva não encontrada"
      });
    }

    res.status(204).send();
  } catch (error) {
    console.error("Erro ao excluir reserva:", error);

    res.status(500).json({
      error: "Erro interno ao excluir reserva"
    });
  }
});

export default router;
