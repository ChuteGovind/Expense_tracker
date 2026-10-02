package com.govind.expensetracker.dto;
import java.math.BigDecimal;
public record CategorySummary(String category,BigDecimal amount,double percentage) {}
