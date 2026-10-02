package com.govind.expensetracker.dto;
import java.math.BigDecimal;
public record MonthlySummary(String month,BigDecimal income,BigDecimal expenses) {}
